class Utilities::QrCodesController < ApplicationController
  def generate
    options = {}

    options[:format] = params[:format] if params[:format]
    options[:size] = params[:size] if params[:size]
    options[:height] = params[:height] if params[:height]

    filename = QrCode.generate(params[:string], options)

    render json: { filename: filename }
  end

  def read_access?
    @read_access ||= current_user.can_read?("tulosta_tuotetarrat.php", classic: true)
  end

  def update_access?
    @update_access ||= current_user.can_update?("tulosta_tuotetarrat.php", classic: true)
  end
end
