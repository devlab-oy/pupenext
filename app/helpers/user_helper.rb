module UserHelper
  def kuka_options
    User.all.order(:nimi).map do |u|
      ["#{u.nimi} (#{u.kuka})", u.kuka]
    end
  end

  def user_taso_options
    [
      [t('activerecord.attributes.user.tasos.acceptor_beginner'), :acceptor_beginner],
      [t('activerecord.attributes.user.tasos.acceptor_basic'),    :acceptor_basic],
      [t('activerecord.attributes.user.tasos.acceptor_admin'),    :acceptor_admin],
      [t('activerecord.attributes.user.tasos.acceptor_super'),    :acceptor_super],
    ]
  end
end
