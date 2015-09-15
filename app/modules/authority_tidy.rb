module AuthorityTidy
  def formatted_ytunnus
    # Return 8 char long string containing only integers
    formatted = ytunnus.gsub /[^0-9]/, ""
    formatted = formatted.rjust 8, "0"
  end
end
