class Reports::FullInstallmentsController < ApplicationController
  def index
  end

  def run
    @data = Reports::FullInstallments.new.run
    @total = @data.map { |h| h[:inventory_value] }.sum

    render :report
  end
end
