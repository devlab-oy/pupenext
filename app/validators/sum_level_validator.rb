class SumLevelValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:taso] << 'should begin with 1, 2 or 3' unless begins_with_1_2_3? record.taso
  end

  def begins_with_1_2_3?(value)
    value.to_s.start_with? "1", "2", "3"
  end
end
