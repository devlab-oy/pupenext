class SalesOrder::Draft < SalesOrder::Base
  validates :tila, inclusion: { in: ['N'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "N"
  end

  def mark_as_done
    LegacyMethods.pupesoft_function(:tilaus_valmis, order_id: id, create_preliminary_invoice: true)
  end
end
