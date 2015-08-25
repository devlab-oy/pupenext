module Current
  def self.company=(company)
    RequestStore.store[:current_company] = company
  end

  def self.company
    RequestStore.store[:current_company]
  end

  def self.user=(user)
    RequestStore.store[:current_user] = user
  end

  def self.user
    RequestStore.store[:current_user]
  end
end
