class CurrentCompanyNil < StandardError
  def message
    'Current.company is not set! Be sure to call Current.company= before using models'
  end
end
