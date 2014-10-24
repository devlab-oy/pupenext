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

  private

    def monitoring_access_control
      render text: t("Käyttöoikeudet puuttuu!"), status: :forbidden unless from_localhost?
    end

    def from_localhost?
      request.remote_ip == "127.0.0.1" || Rails.env.test?
    end
end
