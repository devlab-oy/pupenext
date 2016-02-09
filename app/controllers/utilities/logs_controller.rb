class Utilities::LogsController < ApplicationController
  PATH = "/home/devlab/logs"

  def index
    @files = Dir["#{PATH}/*.log"].map { |file| File.basename(file, ".log") }
  end

  def show
    @file = File.open "#{PATH}/#{params_basename}.log", "r"
  end

  private

    def params_basename
      File.basename params[:name].to_s
    end
end
