module ApplicationHelper
  def sortable(column_name)
    link_to column_name, sort_options(column_name)
  end
end
