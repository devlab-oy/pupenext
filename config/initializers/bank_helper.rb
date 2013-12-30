module BankHelper

  def check_sepa(country)
    # Returns IBAN length for any SEPA country by country code

    sepa_countries = {
      'AL' => 28,
      'AD' => 24,
      'AT' => 20,
      'BE' => 16,
      'BA' => 20,
      'BG' => 22,
      'HR' => 21,
      'CY' => 28,
      'CZ' => 24,
      'DK' => 18,
      'EE' => 20,
      'FO' => 18,
      'FI' => 18,
      'FR' => 27,
      'GE' => 22,
      'DE' => 22,
      'GI' => 23,
      'GR' => 27,
      'GL' => 18,
      'HU' => 28,
      'IS' => 26,
      'IE' => 22,
      'IL' => 23,
      'IT' => 27,
      'KZ' => 20,
      'LV' => 21,
      'LB' => 28,
      'LI' => 21,
      'LT' => 20,
      'LU' => 20,
      'MK' => 19,
      'MT' => 31,
      'MU' => 30,
      'MC' => 27,
      'ME' => 22,
      'NL' => 18,
      'NO' => 15,
      'PL' => 28,
      'PT' => 25,
      'RO' => 24,
      'SM' => 27,
      'SA' => 24,
      'RS' => 22,
      'SK' => 24,
      'SI' => 19,
      'ES' => 24,
      'SE' => 24,
      'CH' => 21,
      'TN' => 24,
      'TR' => 26,
      'GB' => 22
    }

    sepa_countries.fetch(country) if sepa_countries.has_key?(country)
  end

  def validate_iban(iban)
    # Returns valid IBAN or ''
    return '' if iban.kind_of? Numeric or iban.nil?
    iban.gsub!(/\s+/, "")
    errors.add(:iban, 'is not valid') if iban.to_s.nil? || iban.to_s.empty?

    iban.upcase!

    errors.add(:iban, "#{iban[0..1]} is not a valid SEPA country code") unless check_sepa(iban[0..1])

    if check_sepa(iban[0..1]) != iban.length
      errors.add(:iban, "in #{iban[0..1]} should have length of #{check_sepa(iban[0..1])}")
    end

    check = iban.gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
    errors.add(:iban, "is not a valid IBAN") unless (check[6..check.length-1].to_s+check[0..5].to_s).to_i % 97 == 1
    return '' if errors.present?
    iban
  end

  def validate_account_number(account_number)
    # Returns valid account number or ''
    errors.add(:tilino, 'is not valid') if account_number.empty?

    account_number.gsub!(/[^0-9]/, '')
    bank = account_number[0]
    check = 0

    if account_number.length != 14

      case bank
      when '4', '5'
        beginning = account_number[0..6]
        zeroes = "000000000"[0..13-account_number.length]
        ending = account_number[7..-1]
      when '9'
        return account_number
      else
        beginning = account_number[0..5]
        zeroes = "000000000"[0..13-account_number.length]
        ending = account_number[6..-1]
      end
      return '' if [beginning, zeroes, ending].include? nil
      account_number = beginning + zeroes + ending

    end

    check = 0
    (0..12).each do |i|

      if i % 2 == 0
        multi = 2
      else
        multi = 1
      end
      result = multi * account_number[i].to_i

      if result > 9
        result = result.to_s[0].to_i + result.to_s[1].to_i
      end
      check  += result

    end
    check = 10 - check.to_s[-1].to_i

    check = 0 if check.to_i == 10

    if account_number[13] == '' || account_number[13].to_i != check
      errors.add(:tilino, "check value mismatch #{account_number[13]} and #{check}")
      return ''
    end
    account_number
  end

  def create_iban(account_number)
    account_number = validate_account_number(account_number)
    errors.add(:tilino, "asd") if account_number.empty?
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
