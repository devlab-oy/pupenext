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

  def validate_iban(iban)
    # Returns valid IBAN or empty string
    return '' if iban.kind_of? Numeric or iban.nil?
    iban.gsub!(/\s+/, "")
    errors.add(:iban, 'is not valid') if iban.to_s.nil? || iban.to_s.empty?

    iban.upcase!

    errors.add(:iban, "does not have a valid SEPA country code") unless check_sepa(iban[0..1])

    if check_sepa(iban[0..1]) != iban.length
      errors.add(:iban, "in #{iban[0..1]} should have length of #{check_sepa(iban[0..1])}")
    end

    check = iban.gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
    errors.add(:iban, "is not a valid IBAN") unless (check[6..check.length-1].to_s+check[0..5].to_s).to_i % 97 == 1
    return '' if errors.present?

    iban
  end

  def validate_account_number(account_number)
    # Returns valid account number or empty string

    account_number.gsub!(/[^0-9]/, '')
    return account_number if account_number[0] == '9' #Internal bank bypass

    if account_number.length != 14
      account_number = pad_account_number(account_number)
    end

    if account_number.empty?
      errors.add(:tilino, 'is not valid')
      return ''
    end

    if !valid_luhn?(account_number)
      errors.add(:tilino, 'is not a valid Luhn value')
      return ''
    end

    account_number
  end

  def pad_account_number(account_number)
    bank = account_number[0]
    case bank
      when '4', '5'
        beginning = account_number[0..6]
        zeroes = "000000000"[0..13-account_number.length]
        ending = account_number[7..-1]
      else
        beginning = account_number[0..5]
        zeroes = "000000000"[0..13-account_number.length]
        ending = account_number[6..-1]
      end
    return '' if [beginning, zeroes, ending].include? nil

    beginning + zeroes + ending
  end

  def valid_luhn?(value)
    checksum(value, :odd) % 10 == 0
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

  def create_iban(account_number)
    account_number = validate_account_number(account_number)
    errors.add(:tilino, 'not valid') if account_number.empty?
    forcalc = account_number + "FI00".gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
    check = 98 - (forcalc.to_i % 97)
    check = "0"<<check.to_s if check < 10

    generated_iban = "FI#{check}"<<account_number.to_s
    validate_iban(generated_iban)
  end

  def validate_bic(bic)
    bic =~ /^[A-Z]{6,6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3,3}){0,1}$/
  end

end
