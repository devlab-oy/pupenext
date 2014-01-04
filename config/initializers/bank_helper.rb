module BankHelper

  def check_sepa(country)
    # Returns IBAN length for any SEPA country by country code

    sepa_countries = {
      'AL' => 28, 'AD' => 24, 'AT' => 20,
      'BE' => 16, 'BA' => 20, 'BG' => 22,
      'HR' => 21, 'CY' => 28, 'CZ' => 24,
      'DK' => 18, 'EE' => 20, 'FO' => 18,
      'FI' => 18, 'FR' => 27, 'GE' => 22,
      'DE' => 22, 'GI' => 23, 'GR' => 27,
      'GL' => 18, 'HU' => 28, 'IS' => 26,
      'IE' => 22, 'IL' => 23, 'IT' => 27,
      'KZ' => 20, 'LV' => 21, 'LB' => 28,
      'LI' => 21, 'LT' => 20, 'LU' => 20,
      'MK' => 19, 'MT' => 31, 'MU' => 30,
      'MC' => 27, 'ME' => 22, 'NL' => 18,
      'NO' => 15, 'PL' => 28, 'PT' => 25,
      'RO' => 24, 'SM' => 27, 'SA' => 24,
      'RS' => 22, 'SK' => 24, 'SI' => 19,
      'ES' => 24, 'SE' => 24, 'CH' => 21,
      'TN' => 24, 'TR' => 26, 'GB' => 22
    }

    sepa_countries.fetch(country) if sepa_countries.has_key?(country)
  end

  def valid_iban?(value)
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
    value =~ /^[A-Z]{6,6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3,3}){0,1}$/
  end

  def valid_account_number?(value)
    account_number = pad_account_number(value)
    valid_luhn?(account_number)
  end

  def valid_luhn?(value)
    checksum(value, :odd) % 10 == 0
  end

  def pad_account_number(value)
    # Convert to string
    account_number = value.to_s

    # Remove all non-digits
    account_number.gsub!(/\D/, '')

    # How much do we have to pad
    zeroes = 14 - account_number.length

    # Bank identifier
    bank = account_number[0]

    case bank
    when '4', '5'
      position = 7
    else
      position = 6
    end

    account_number.insert(position, "0" * zeroes)
  end

  def checksum(value, operation)
    i = 0
    compare_method = (operation == :even) ? :== : :>
    value.reverse.split('').inject(0) do |sum, c|
      n = c.to_i
      weight = (i % 2).send(compare_method, 0) ? n * 2 : n
      i += 1
      sum += weight < 10 ? weight : weight - 9
    end
  end

  def create_iban(value)
    # Creates IBAN number from Finnish account number
    return false unless valid_account_number?(value)

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
