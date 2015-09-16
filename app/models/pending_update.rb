class PendingUpdate < ActiveRecord::Base
  include CurrentUser
  include UserDefinedValidations

  belongs_to :pending_updatable, polymorphic: true

  validates :key, presence: true
  validates :value_type, presence: true, inclusion: {
    in: %w(Date DateTime Decimal Float Integer String Text Time Timestamp)
  }

  validate :attributes

  def attributes
    hash = {}
    obj = pending_updatable_type.classify.constantize

    PendingUpdate.where(pending_updatable_id: pending_updatable_id, pending_updatable_type: pending_updatable_type).each do |attr|
      hash[attr.key] = attr.value
    end

    hash[key] = value

    x = obj.find pending_updatable_id
    x.attributes = hash

    errors.add(:value, x.errors.full_messages.join) unless x.valid?
  end
end
