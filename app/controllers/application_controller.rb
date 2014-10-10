class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale

  helper_method :current_user
  helper_method :t

  private

    def current_user
      @current_user ||= User.find_by_session(cookies[:pupesoft_session])
    end

    def t(string)
      language = current_user ? current_user.locale : nil
      Dictionary.translate(string, language)
    end

  protected

    def authorize
      render text: t("Kielletty!"), status: :unauthorized unless current_user
    end

    def set_locale
      I18n.locale = current_user.locale || I18n.default_locale
    end

    def resource_search(resource)
      raise ArgumentError if resource.empty?

      _class = resource.first.class

      # Current resource's table definition
      table = _class.arel_table

      # Allow search only for current resource's columns
      search_fields = params.permit(_class.column_names)

      # Remove empty values
      search_fields.reject! { |i| i.nil? }

      search_fields.each do |key, value|
        column = table[key]
        search = "%#{value}%".to_sym
        resource = resource.where(column.matches(search))
      end

      resource
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
