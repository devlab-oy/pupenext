class QrCodesController < ApplicationController
  def generate
    options = {}

    options[:format] = params[:format] if params[:format]
    options[:size] = params[:size] if params[:size]
    options[:height] = params[:height] if params[:height]

    filename = QrCode.generate(params[:string], options)

    render json: { filename: filename }
  end
end
