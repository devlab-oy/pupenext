class SumLevel::Internal < SumLevel

  validate :should_begin_with

  default_scope { where(tyyppi: self.sti_name) }

  def should_begin_with
    valid_characters = [
      '1',
      '2',
      '3',
    ]

    is_valid = taso.to_s.start_with? *valid_characters
    errors.add(:taso, 'should begin with 1, 2 or 3') unless is_valid
  end

  def self.sti_name
    'S'
  end
end
