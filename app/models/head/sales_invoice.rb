class Head::SalesInvoice < Head
  include AuthorityTidy

  validates :tila, inclusion: { in: ['U'] }
  has_many :rows, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoiceRow'

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end

  def maa
    read_attribute(:maa).upcase
  end

  def ytunnus_human
    return ytunnus unless maa == "FI" || maa == "SE"

    if maa == "FI"
      # The second to last char is a dash in a Finnish Y-tunnus
      formatted_ytunnus.insert 7, '-'
    elsif maa != company.maa && ytunnus.trim.upcase[0,2] != maa
      # Swedish Y-tunnus SE-123467
      "#{maa}-formatted_ytunnus"
    end
  end

  def vatnumber_human
    return ytunnus unless maa == "FI"

    # FI+ytunnus makes up the Finnish VAT-number
    "FI#{formatted_ytunnus}"
  end

  def deliveryperiod_start
    if company.parameter.no_manual_deliverydates?
      rows.minimum(:toimitettuaika).to_date
    else
      rows.minimum(:toimaika)
    end
  end

  def deliveryperiod_end
    if company.parameter.no_manual_deliverydates?
      rows.maximum(:toimitettuaika).to_date
    else
      rows.maximum(:toimaika)
    end
  end
end
