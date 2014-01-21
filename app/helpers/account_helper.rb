module AccountHelper

  def account_name(number)
    a = Account.find_by_tilino(number)
    a.present? ? a.nimi : ""
  end

end
