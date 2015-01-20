class Head::VoucherRow < ActiveRecord::Base
  belongs_to :voucher, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::Voucher'

  self.table_name = :tiliointi
  self.primary_key = :tunnus

  before_save :defaults

  private

    def defaults
      self.laadittu ||= Date.today
      self.korjausaika ||= Date.today
    end
end
