class InvoicesController < ApplicationController
  def show
    respond_to do |format|
      format.xml { render :finvoice }
    end
  end
end
