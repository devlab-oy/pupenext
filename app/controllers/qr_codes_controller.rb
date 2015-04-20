class QrCodesController < ApplicationController
  def generate
    options = {}

    options[:format] = params[:format] if params[:format]

    filename = QrCode.generate(params[:string], options)

    render json: { filename: filename }
  end
end
