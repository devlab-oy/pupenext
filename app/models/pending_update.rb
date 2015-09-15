class PendingUpdate < ActiveRecord::Base
  include CurrentUser
  include UserDefinedValidations

  belongs_to :pending_updatable, polymorphic: true

  validates :key, presence: true
  validates :value_type, presence: true, inclusion: {
    in: %w(Date DateTime Decimal Float Integer String Text Time Timestamp)
  }
end
