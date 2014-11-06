class SumLevelValidator < ActiveModel::Validator
  def validate(record)
    unless should_begin_with(record)
      record.errors[:taso] << 'should begin with 1, 2 or 3'
    end
  end

  def should_begin_with(record)
    valid_characters = [
      '1',
      '2',
      '3',
    ]

    is_valid = record.taso.to_s.start_with? *valid_characters

    is_valid
  end

end
