# ColumnSort module requires the controller to implement next methods:
#
# sortable_columns :taso, :tyyppi, :nimi,
# default_sort_column :tunnus
module ColumnSort
  extend ActiveSupport::Concern

  included do
    helper_method :sort_options
  end

  # Returns the column name the sorting should happen with
  # The returned column name is either the one given in HTTP request :sort or the one returned by
  # default_sort_column method
  # If the column name is given in HTTP request it has to be found in sortable_columns method
  def sort_column
    return params[:sort] if get_sortable_columns.include? params[:sort].try(:to_sym)

    get_default_sort_column
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  # Sort options for link_to method
  # To be used like this:
  #   link_to column_name, sort_options(column_name)
  def sort_options(column)
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    options = {}
    options['sort'] = column
    options['direction'] = direction
    options['not_used'] = params[:not_used]

    # If controller implements params_search, add search params to sort url
    options.merge! filter_search_params unless filter_search_params.nil?

    options
  end

  def filter_search_params
    p = params.permit(searchable_columns)

    p.reject { |_, v| v.empty? }
  end

  def sortable(column_name)
    link_to column_name, sort_options(column_name)
  end

  module ClassMethods
    def sortable_columns(*columns)
      define_method("get_sortable_columns") do
        columns
      end
    end

    def default_sort_column(column_name)
      define_method("get_default_sort_column") do
        column_name
      end
    end
  end
end
