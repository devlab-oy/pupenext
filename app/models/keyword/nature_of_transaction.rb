class Keyword::NatureOfTransaction < Keyword
  def self.sti_name
    'KT'
  end

  def self.valid_values
    pluck(:selite).map(&:to_i) + [0]
  end
end
