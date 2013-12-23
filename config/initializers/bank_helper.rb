module BankHelper

  def check_sepa(country)

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

    return false unless sepa_countries.has_key?(country)
    sepa_countries.fetch(country)
  end

end