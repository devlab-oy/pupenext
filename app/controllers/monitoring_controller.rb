class MonitoringController < ApplicationController
  include ResqueMonitor

  skip_before_action :authorize
  skip_before_action :set_locale
  skip_before_action :access_control

  before_action :monitoring_access_control

  def nagios_resque_email
    status = ResqueMonitor.nagios_resque_email
    render text: status
  end

  def nagios_resque_failed
    status = ResqueMonitor.nagios_resque_failed
    render text: status
  end

  private

    def monitoring_access_control
      render text: t("Käyttöoikeudet puuttuu!"), status: :forbidden unless from_devlab?
    end

    def from_devlab?
      request.remote_ip == "82.181.128.118" || Rails.env.test?
    end
end
