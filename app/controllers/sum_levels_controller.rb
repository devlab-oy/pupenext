class SumLevelsController < ApplicationController
  COLUMNS = [
    :taso,
    :tyyppi,
    :nimi,
    :summattava_taso,
    :kumulatiivinen,
    :oletusarvo,
    :kerroin,
    :jakaja,
  ]

  sortable_columns *COLUMNS
  default_sort_column :tunnus

  def index
    @sum_levels = current_company.sum_levels
    @sum_levels = @sum_levels.search_like filter_search_params
    @sum_levels = @sum_levels.order("#{sort_column} #{sort_direction}")
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

  private

    def searchable_columns
      COLUMNS
    end
end
