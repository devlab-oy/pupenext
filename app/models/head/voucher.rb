class Head::Voucher < ActiveRecord::Base
  has_one :accounting_fixed_assets_commodity, foreign_key: :tunnus, primary_key: :hyodyke_tunnus

  validates :tila, inclusion: { in: ['X'] }

  self.table_name = :lasku
  self.primary_key = :tunnus

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "X"
  end

  def self.human_readable_type
    "Tosite"
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Head.model_name
  end

  private

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end
end
