class PrintersController < ApplicationController
  include ApplicationHelper

  before_action :find_printer, only: [:show, :edit, :update, :destroy]

  # GET /printers
  def index
    @printers = current_company.printer.all
  end

  # GET /printers/1
  def show
    render 'edit'
  end

  # GET /printers/new
  def new
    @printer = current_company.printer.build
  end

  # POST /printers
  def create
    @printer = current_company.printer.build
    @printer.attributes = printer_params
    @printer.muuttaja = current_user.kuka
    @printer.laatija = current_user.kuka

    if @printer.save
      redirect_to @printer, notice: 'Printer was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /printers/1/edit
  def edit

  end

  # PATCH/PUT /printers/1
  def update
    @printer.muuttaja = current_user.kuka

    if @printer.update(printer_params)
      redirect_to printers_path, notice: 'Printer was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def printer_params
      params[:printer].permit(
        :nimi,
        :jarjestys,
        :kurssi,
      )
    end

    def find_printer
      @printer = current_company.printer.find(params[:id])
    end
end
