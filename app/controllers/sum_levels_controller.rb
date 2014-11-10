class SumLevelsController < ApplicationController
  def index
    @sum_levels = current_company.sum_levels
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
