class Currency < BaseModel
  include AttributeSanitator
  include Searchable
  include UserDefinedValidations

  before_validation :name_to_uppercase
  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }
  validates :kurssi, numericality: true
  validates :intrastat_kurssi, numericality: true
  validates :jarjestys, numericality: { only_integer: true }

  float_columns :kurssi, :intrastat_kurssi

  self.table_name = :valuu
  self.primary_key = :tunnus

  private

    def name_to_uppercase
      if nimi.present?
        nimi.strip!
        nimi.upcase!
      end
    end
end
