class Head < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :terms_of_payment, foreign_key: :maksuehto, primary_key: :tunnus
  has_many :accounting_rows, class_name: 'Head::VoucherRow', foreign_key: :ltunnus

  scope :not_delivered, -> { where(tila: 'L', alatila: %w(A C)) }
  scope :not_finished, -> { where(tila: 'N') }

  self.table_name = :lasku
  self.primary_key = :tunnus
  self.inheritance_column = :tila

  def self.child_class(value)
    child_class_names[value.try(:to_sym)]
  end

  def self.default_child_instance
    child_class :N
  end

  def self.child_class_names
    {
      H: Head::PurchaseInvoice::Approval,
      Y: Head::PurchaseInvoice::Paid,
      M: Head::PurchaseInvoice::Approved,
      P: Head::PurchaseInvoice::Transfer,
      Q: Head::PurchaseInvoice::Waiting,
      O: Head::PurchaseOrder,
      U: Head::SalesInvoice,
      N: Head::SalesOrder,
      X: Head::Voucher,
    }
  end

  # This functions purpose is to return the child class name.
  # Aka. it should allways return .constantize
  # This function is called from   persistence.rb function: instantiate
  #                             -> inheritance.rb function: discriminate_class_for_record
  # This is the reason we need to map the db column with correct child class in this model
  # type_name = "S", type_name = "U" ...
  def self.find_sti_class(value)
    child_class value
  end

  # This method is originally defined in inheritance.rb and needs to be overridden, so that
  # rails knows how to initialize a proper subclass because the subclass name is different than the
  # value in the inheritance column.
  def self.subclass_from_attributes(attrs)
    subclass_name = attrs.with_indifferent_access[inheritance_column]
    subclass_name = child_class(subclass_name).to_s

    if subclass_name.present? && subclass_name != self.name
      return subclass_name.safe_constantize
    end

    nil
  end
end
