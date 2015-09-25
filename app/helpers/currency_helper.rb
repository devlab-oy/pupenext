module CurrencyHelper
  def currency_options
    Currency.order(:jarjestys).map do |c|
      [ c.nimi, c.nimi ]
    end
  end
end
