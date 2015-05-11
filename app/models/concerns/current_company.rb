module CurrentCompany
  extend ActiveSupport::Concern

  included do
    validates :yhtio, presence: true

    after_initialize do |record|
      record.company ||= Company.current
    end
  end

  module ClassMethods
    def default_scope
      -> { where(yhtio: Company.current.yhtio) }
    end
  end
end
