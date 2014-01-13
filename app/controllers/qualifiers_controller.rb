class QualifiersController < ApplicationController

  before_action :find_qualifier, only: [:show, :edit, :update]
  before_action :find_isa_options, only: [:new, :show, :create, :edit, :update]

  def index
    @qualifiers = current_user.company.qualifiers
  end

  def show
    render 'edit'
  end

  def edit
  end

  def new
    @qualifier = current_user.company.qualifiers.build
  end

  def create
    @qualifier = current_user.company.qualifiers.build
    @qualifier.attributes = qualifier_params
    @qualifier.muuttaja = current_user.kuka
    @qualifier.laatija = current_user.kuka

    if @qualifier.save
      redirect_to qualifiers_path, notice: 'Qualifier was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @qualifier.attributes = qualifier_params
    @qualifier.muuttaja = current_user.kuka

    if @qualifier.save
      redirect_to qualifiers_path, notice: 'Qualifier was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

    def find_isa_options
      @isa_options = current_user.company.qualifiers
    end

    def find_qualifier
      @qualifier = current_user.company.qualifiers.find(params[:id])
    end

    def qualifier_params
        params.require(:qualifier).permit(
          :nimi,
          :koodi,
          :tyyppi,
          :kaytossa,
          :isa_tarkenne
        )
    end



end
