class SumLevel < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = 'taso'
  self.primary_key = 'tunnus'
  self.inheritance_column = :tyyppi
  self.abstract_class = true

  validates :taso, presence: true
  validates :nimi, presence: true
  validate :does_not_contain_char
  validates_uniqueness_of :taso, scope: :tyyppi

  def sum_level_name
    "#{taso} #{nimi}"
  end

  def self.sum_levels
    hash = {
      S: 'SumLevel::Internal',
      U: 'SumLevel::External',
      A: 'SumLevel::Vat',
      B: 'SumLevel::Profit',
    }

    hash
  end

  def self.child_class(db_column_value)
    sum_levels = self.sum_levels

    sum_levels[db_column_value.to_sym].constantize
  end

  # This functions purpose is to return the child class name.
  # Aka. it should allways return .constantize
  # This function is called from   persistence.rb function: instantiate
  #                             -> inheritance.rb function: discriminate_class_for_record
  # This is the reason we need to map the db column with correct child class in this model
  # type_name = 'S', type_name = 'U' ...
  def self.find_sti_class(type_name)
    child_class type_name
  end

  private

    def does_not_contain_char
      not_allowed_character = 'Ö'

      errors.add(:taso, 'can not contain Ö') if taso.to_s.include? not_allowed_character
    end

end
