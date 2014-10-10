module ApplicationHelper

  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

  def current_company
    @current_company ||= current_user.company
  end

  def sortable(column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options = {}
    options['sort'] = column
    options['direction'] = direction
    options['not_used'] = params[:not_used]

    # If controller implements params_search, add search params to sort url
    params_search.merge! options if respond_to? :params_search

    link_to column, options
  end
end
