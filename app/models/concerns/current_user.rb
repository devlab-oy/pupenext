module CurrentUser
  extend ActiveSupport::Concern

  included do
    before_save :update_record_user_and_timestamps
  end

  private

    def update_record_user_and_timestamps
      name = Current.user.try(:kuka) || return

      self.modified_by = name     if respond_to?(:modified_by=)
      self.muuttaja    = name     if respond_to?(:muuttaja=)
      self.muutospvm   = Time.now if respond_to?(:muutospvm=)

      # if this is a new record, also update created user/time
      unless persisted?
        self.created_by = name     if respond_to?(:created_by=)
        self.laatija    = name     if respond_to?(:laatija=)
        self.luontiaika = Time.now if respond_to?(:luontiaika=)
      end
    end
end
