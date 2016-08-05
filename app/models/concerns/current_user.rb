module CurrentUser
  extend ActiveSupport::Concern

  included do
    before_save :update_record_timestamps, :update_record_user
  end

  private

    def update_record_timestamps
      self.muutospvm  = Time.zone.now if respond_to?(:muutospvm=)
      self.luontiaika = Time.zone.now if respond_to?(:luontiaika=) && !luontiaika.present?

      return if persisted?

      # if this is a new record, also update created time
      self.luontiaika = Time.zone.now if respond_to?(:luontiaika=)
    end

    def update_record_user
      name = Current.user.try(:kuka) || return

      self.modified_by = name if respond_to?(:modified_by=)
      self.muuttaja    = name if respond_to?(:muuttaja=)
      self.laatija     = name if respond_to?(:laatija=) && !laatija.present?

      return if persisted?

      # if this is a new record, also update created user/time
      self.created_by = name if respond_to?(:created_by=)
      self.laatija    = name if respond_to?(:laatija=)
    end
end
