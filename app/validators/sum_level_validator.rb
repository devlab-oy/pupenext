class SumLevelValidator < ActiveModel::Validator
  def validate(record)
    error = I18n.t 'errors.sum_level.begin_with_error'
    record.errors[:taso] << error unless begins_with_1_2_3?(record.taso, record.tyyppi)
  end

  def begins_with_1_2_3?(value, type)
    # Commodity sumlevels are usually letters: A, B, C etc
    return true if type == 'E'
    value.to_s.start_with? "1", "2", "3"
  end
end
