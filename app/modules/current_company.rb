module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Company.current
    end
  end

  module ClassMethods
    def default_scope
      -> { where(yhtio: Company.current.yhtio) } if Company.current
    end
  end
end
