# ColumnSort module requires the controller to implement the methods:
#
# sortable_columns
# searchable_columns
#
# They should return array of allowed column names
module ColumnSort
  extend ActiveSupport::Concern

  included do
    helper_method :sortable
  end

  # Helper method for views to create link for sorting index
  def sortable(column_name, link_text = nil)
    link = link_text ? link_text : column_name
    view_context.link_to link, sort_options(column_name), class: 'sort-link'
  end

  def search_params
    params.permit(searchable_columns).reject { |_, v| v.empty? }
  end

  def order_params
    "#{sort_column} #{sort_direction}"
  end

  private

    # Check that the sort column is in the whitelist. Otherwise sort by first item.
    def sort_column
      return params[:sort] if sortable_columns.include? params[:sort].try(:to_sym)

      sortable_columns.first
    end

    # Check that sort direction is in the whitelist. Otherwise sort by asc.
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    # Sort options for sortable method
    def sort_options(column)
      direction = (column.to_s == sort_column && sort_direction == "asc") ? "desc" : "asc"

      options = {
        sort: column,
        direction: direction,
        not_used: params[:not_used]
      }

      # If controller implements searchable_columns, add search params to sort url
      options.merge! search_params unless searchable_columns.nil?
      options
    end
end
