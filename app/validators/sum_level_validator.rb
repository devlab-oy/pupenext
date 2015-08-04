class SumLevelValidator < ActiveModel::Validator
  def validate(record)
    error = I18n.t 'activerecord.models.sum_level.errors.begin_with_error'
    record.errors[:taso] << error unless begins_with_1_2_3? record.taso
  end

  def begins_with_1_2_3?(value)
    value.to_s.start_with? "1", "2", "3"
  end
end
