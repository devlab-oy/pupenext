class Attachment::ProductAttachment < Attachment
  def self.sti_name
    'tuote'
  end

  belongs_to :product, foreign_key: :liitostunnus

  scope :images, -> { where(kayttotarkoitus: :tk) }
  scope :thumbnails, -> { where(kayttotarkoitus: :th) }
end
