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

  private
    def user_agent_include?(value)
      request.user_agent.downcase.include? value.to_s.downcase
    end
end
