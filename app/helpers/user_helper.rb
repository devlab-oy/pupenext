module UserHelper
  def kuka_options
    User.all.order(:nimi).map do |u|
      [ "#{u.nimi} (#{u.kuka})", u.kuka ]
    end
  end
end
