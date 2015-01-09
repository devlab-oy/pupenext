class Company < ActiveRecord::Base
  with_options foreign_key: :yhtio, primary_key: :yhtio do |options|
    options.has_many :keywords

    options.has_many :users
    options.has_one :parameter
    options.has_many :accounts
    options.has_many :currency

    options.has_many :sum_levels
    options.has_many :sum_level_internals, class_name: 'SumLevel::Internal'
    options.has_many :sum_level_externals, class_name: 'SumLevel::External'
    options.has_many :sum_level_vats, class_name: 'SumLevel::Vat'
    options.has_many :sum_level_profits, class_name: 'SumLevel::Profit'

    options.has_many :cost_centers, class_name: 'Qualifier::CostCenter'
    options.has_many :projects, class_name: 'Qualifier::Project'
    options.has_many :targets, class_name: 'Qualifier::Target'
  end

  # Map old database schema table to Company class
  self.table_name = "yhtio"
  self.primary_key = "tunnus"

  def classic_ui?
    parameter.kayttoliittyma == 'C' || parameter.kayttoliittyma.blank?
  end
end
