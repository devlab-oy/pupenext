class SumLevel < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :taso
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi
  self.abstract_class = true

  validates :taso, presence: true
  validates :tyyppi, inclusion: { in: %w[S A U B] }
  validate :does_not_contain_char
  validates_uniqueness_of :taso, scope: :tyyppi

  def sum_level_name
    "#{taso} #{nimi}"
  end

  private
    def self.sum_levels
      {
        S: 'SumLevel::Internal',
        U: 'SumLevel::External',
        A: 'SumLevel::Vat',
        B: 'SumLevel::Profit',
      }
    end

    # This functions purpose is to return the child class name.
    # Aka. it should allways return .constantize
    # This function is called from   persistence.rb function: instantiate
    #                             -> inheritance.rb function: discriminate_class_for_record
    # This is the reason we need to map the db column with correct child class in this model
    # type_name = 'S', type_name = 'U' ...
    def self.find_sti_class(taso_value)
      sum_levels[taso_value.to_sym].constantize
    end

    def does_not_contain_char
      errors.add(:taso, "can not contain Ö") if taso.to_s.include? "Ö"
    end
end
