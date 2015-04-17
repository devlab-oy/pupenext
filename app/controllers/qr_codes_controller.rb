class QrCodesController < ApplicationController
  def generate
    filename = QrCode.generate(params[:string])

    render json: { filename: filename }
  end
end
