class PendingUpdate < ActiveRecord::Base
  include CurrentUser
  include UserDefinedValidations

  belongs_to :pending_updatable, polymorphic: true
end
