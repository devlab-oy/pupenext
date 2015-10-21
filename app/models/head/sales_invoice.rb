class Head::SalesInvoice < Head
  include AuthorityTidy

  validates :tila, inclusion: { in: ['U'] }
  has_many :rows, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoiceRow'
  has_one :extra, foreign_key: :otunnus, primary_key: :tunnus, class_name: 'Head::SalesInvoiceExtra'
  has_one :seller, foreign_key: :tunnus, primary_key: :myyja, class_name: 'User'

  scope :sent, -> { where(alatila: :X) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end

  def maa
    read_attribute(:maa).upcase
  end

  def credit?
    arvo < 0
  end

  def ytunnus_human
    return ytunnus unless maa == "FI" || maa == "SE"

    if maa == "FI"
      # The second to last char is a dash in a Finnish Y-tunnus
      formatted_ytunnus.insert 7, '-'
    elsif maa != company.maa && ytunnus.strip.upcase[0,2] != maa
      # Swedish Y-tunnus SE-123467
      "#{maa}-#{ytunnus}"
    else
      ytunnus
    end
  end

  def vatnumber_human
    return ytunnus unless maa == "FI"

    # FI+ytunnus makes up the Finnish VAT-number
    "FI#{formatted_ytunnus}"
  end

  def company_vatnumber_human
    return yhtio_ovttunnus unless maa == "FI"

    # FI+ytunnus makes up the Finnish VAT-number
    "FI#{formatted_company_vatnumber}"
  end

  def deliveryperiod_start
    rows.map(&:delivery_date).min
  end

  def deliveryperiod_end
    rows.map(&:delivery_date).max
  end

  def vat_specification
    # We should return an array of hashes with amounts per tax class
    vat_rates.map do |tax|
     {
       vat_rate: tax,
       vat_code: vat_code(tax),
       base_amount: vat_base(tax),
       vat_amount: vat_amount(tax)
     }
    end
  end

  private
    def vat_rates
      rows.select(:alv).map(&:alv).uniq.sort
    end

    def vat_base(vat_rate)
      rows.where(alv: vat_rate).to_a.sum(&:rivihinta).round(2)
    end

    def vat_amount(vat_rate)
      rows.where(alv: vat_rate).to_a.sum { |r| r.rivihinta * r.vat_percent/100 }.round(2)
    end

    def vat_code(vat_rate)
      if vat_rate >= 600
        "AE" # VAT Reverse Charge
      elsif vat_rate >= 500
        "AB" # Exempt for resale
      elsif vienti == "E"
        "E" # Exempt from tax
      elsif vienti == "K"
        "G" # Free export item, tax not charged
      else
        "S" # Standard rate
      end
    end
end
