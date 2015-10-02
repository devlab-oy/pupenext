class DownloadsController < ApplicationController
  def index
    @downloads = current_user.downloads
  end

  def show
    file = current_user.files.find params[:id]

    parameters = {
      filename: file.filename,
      type: MIME::Types.type_for(file.filename).first.content_type,
    }

    send_data file.data, parameters
  end

  def destroy
    download = current_user.downloads.find params[:id]
    download.destroy

    redirect_to downloads_path
  end
end
