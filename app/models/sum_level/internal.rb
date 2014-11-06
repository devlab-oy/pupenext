class SumLevel::Internal < SumLevel

  validate :should_begin_with

  default_scope { where(tyyppi: self.sti_name) }

  def should_begin_with
    should_begin_with = [
      '1',
      '2',
      '3',
    ]

    sum_level_first_char = taso[0, 1]
    begins_with = should_begin_with.include?(sum_level_first_char)
    errors.add(:taso, 'should begin with 1, 2 or 3') unless begins_with
  end

  def self.sti_name
    'S'
  end
end
