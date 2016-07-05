class Reports::FullInstallmentsController < ApplicationController
  def index
  end

  def run
    @data = Reports::FullInstallments.new.run
    @total = @data.map { |h| h[:inventory_value] }.sum

    respond_to do |format|
      format.html { render :report }
      format.xlsx { render :report }
    end
  end
end
