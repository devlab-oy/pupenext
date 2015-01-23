class Head::Voucher < Head
  belongs_to :commodity, class_name: 'FixedAssets::Commodity'
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::VoucherRow'

  validates :tila, inclusion: { in: ['X'] }

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

  def create_voucher_row(params)
    row_params = {
      laatija: params[:created_by],
      tapvm: params[:transacted_at],
      yhtio: params[:yhtio],
      summa: params[:amount],
      selite: params[:description],
      tilino: params[:account]
    }
    rowi = rows.build row_params
    rowi.save
  end

  private

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end
end
