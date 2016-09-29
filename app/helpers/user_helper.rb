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

  def user_temp_acceptor_options
    User.temp_acceptors.order(:nimi).map do |u|
      ["#{u.nimi} (#{u.kuka})", u.kuka]
    end
  end

  def user_order_ready_options
    node = 'activerecord.attributes.user.tilaus_valmiss'

    [
      [t("#{node}.order_ready_ok"),              :order_ready_ok],
      [t("#{node}.order_ready_approve"),         :order_ready_approve],
      [t("#{node}.order_ready_approve_foreign"), :order_ready_approve_foreign],
      [t("#{node}.order_ready_denied"),          :order_ready_denied],
    ]
  end
end
