module AuthorityTidy
  def formatted_ytunnus
    # Return 8 char long string containing only integers
    formatted = ytunnus.gsub /[^0-9]/, ""
    formatted = formatted.rjust 8, "0"
  end

  def formatted_company_vatnumber
    # Return 8 char long string containing only integers
    formatted = yhtio_ovttunnus.gsub /[^0-9]/, ""
    formatted = yhtio_ovttunnus.gsub /0037/, ""
    formatted = formatted.rjust 8, "0"
  end

end
