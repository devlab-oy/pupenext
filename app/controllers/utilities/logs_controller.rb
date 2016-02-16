class Utilities::LogsController < ApplicationController
  PATH = "/home/devlab/logs"

  def index
    @files = Dir["#{PATH}/*.log"].map { |file| File.basename(file, ".log") }
  end

  def show
    send_file "#{PATH}/#{params_basename}.log", type: 'text/plain'
  end

  private

    def params_basename
      File.basename params[:name].to_s
    end
end
