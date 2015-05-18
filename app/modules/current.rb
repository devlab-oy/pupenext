module Current
  def self.company=(company)
    RequestStore.store[:current_company] = company
  end

  def self.company
    RequestStore.store[:current_company]
  end
end
