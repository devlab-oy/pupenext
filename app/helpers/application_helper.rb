module ApplicationHelper
  def firefox?
    user_agent_include? "firefox"
  end

  def trident?
    user_agent_include? "trident"
  end

  def chrome?
    user_agent_include? "chrome"
  end

  def windows?
    user_agent_include? "windows"
  end

  def return_link(text, path)
    link_to "« #{t("shared.link_return_to")}: #{text}", path
  end

  def enable_pickadate
    content_tag :div, nil, id: :pickadate_data, data: {
      months: I18n.t('date.month_names').compact.map(&:capitalize),
      weekdays: I18n.t('date.abbr_day_names').compact.map(&:capitalize)
    }
  end

  def button_to_new(model_name)
    if update_access?
      name = model_name.to_s.classify.constantize.model_name.human
      path = Rails.application.routes.url_helpers.send "new_#{model_name}_path"
      text = t('helpers.submit.new', model: name)

      button_to text, path, method: :get, params: { alias_set: params[:alias_set] }
    end
  end

  def user_name(kuka)
    User.find_by(kuka: kuka).try(:nimi) || kuka
  end

  private

    def user_agent_include?(value)
      request.user_agent.downcase.include? value.to_s.downcase
    end
end
