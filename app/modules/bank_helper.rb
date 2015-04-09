module BankHelper

  def check_sepa(country)
    country = country.to_sym
    # Returns IBAN length for any SEPA country by country code

    sepa_countries = {
      AL: 28, AD: 24, AT: 20,
      BE: 16, BA: 20, BG: 22,
      HR: 21, CY: 28, CZ: 24,
      DK: 18, EE: 20, FO: 18,
      FI: 18, FR: 27, GE: 22,
      DE: 22, GI: 23, GR: 27,
      GL: 18, HU: 28, IS: 26,
      IE: 22, IL: 23, IT: 27,
      KZ: 20, LV: 21, LB: 28,
      LI: 21, LT: 20, LU: 20,
      MK: 19, MT: 31, MU: 30,
      MC: 27, ME: 22, NL: 18,
      NO: 15, PL: 28, PT: 25,
      RO: 24, SM: 27, SA: 24,
      RS: 22, SK: 24, SI: 19,
      ES: 24, SE: 24, CH: 21,
      TN: 24, TR: 26, GB: 22
    }

    sepa_countries.fetch(country) if sepa_countries.has_key?(country)
  end

  def valid_iban?(value)
    return false unless value.present?

    # Validation bypass if value contains only letters
    return true if value =~ /\A[a-zA-Z]+\z/

    value.upcase!
    # Clean value
    value.gsub!(/[^A-Z0-9]/, '')

    iban_length = check_sepa(value[0..1])

    # IBAN is invalid if length is not correct
    return false if iban_length.nil? || value.length != iban_length

    # Move four first characters to the end of the string
    iban = value[4..-1].to_s + value[0..3].to_s

    # Convert IBAN to numbers (A=10, B=11, ..., Z=35)
    iban = iban.gsub(/[A-Z]/) { |p| p.ord - 55 }

    # IBAN is valid if remainder is 1
    iban.to_i % 97 == 1
  end

  def valid_bic?(value)
    return false unless value.present?
    value =~ /^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3})?$/
  end

  def valid_account_number?(value)
    return false unless value.present?
    # Validation bypass if value contains only letters
    return true if value =~ /\A[a-zA-Z]+\z/

    account_number = pad_account_number(value)
    valid_luhn?(account_number) && account_number.length == 14
  end

  def valid_luhn?(value)
    # Convert to string
    value = value.to_s

    # Not valid if contains non-digits
    return false unless value =~ /\A[0-9]+\z/

    # Create array of reversed digits
    digits = value.reverse.scan(/./).map(&:to_i)
    sum = 0

    # Loop digits
    digits.each_with_index do |n, i|
      # Every other digit must be multiplied by 2
      n *= 2 if i.odd?

      # If we get more than 10 add numbers together
      n = 1 + (n - 10) if n >= 10

      # Add digit to sum
      sum += n
    end

    # Valid if remainder is zero
    (sum % 10).zero?
  end

  def pad_account_number(value)
    # Convert to string
    value = value.to_s

    # Return value back if only letters
    return value if value =~ /\A[a-zA-Z]+\z/

    # Remove non-digits
    value.gsub!(/\D/, '')

    # Return value back if we cannot pad
    return value unless value.length.between?(6, 14)

    # How much do we have to pad
    zeroes = 14 - value.length

    # Bank identifier
    bank = value[0]

    case bank
    when '4', '5'
      position = 7
    else
      position = 6
    end

    value.insert(position, "0" * zeroes)
  end

  def create_iban(value)
    # Creates IBAN number from Finnish account number
    return false unless valid_account_number?(value)

    # Return value back if only letters
    return value if value =~ /\A[a-zA-Z]+\z/

    account_number = pad_account_number(value)
    iban = account_number + "151800" # 15=F, 18=I
    check = ""

    # Loop iban in 7 character chunks (or less) and calculate check digit
    iban.scan(/.{1,7}/).each do |i|
      check = "#{check}#{i}".to_i
      check = check % 97
    end

    # check digit with leading zero
    check = "%02d" % (98 - check)

    # Return IBAN
    "FI#{check}#{account_number}"
  end

end
