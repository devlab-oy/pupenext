class PendingUpdate < BaseModel
  belongs_to :pending_updatable, polymorphic: true
end
