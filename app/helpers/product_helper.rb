module ProductHelper
  def categories_options
    options_for_select category_filter, params[:osasto]
  end

  def subcategories_options
    options_for_select subcategory_filter, params[:try]
  end

  def brands_options
    options_for_select brand_filter, params[:tuotemerkki]
  end

  def product_status_options
    statuses = [
      %w(Aktiivi A),
      %w(Ennakkotuote E),
      %w(Tilaustuote T),
      %w(Poistettu P),
    ]

    statuses += Product::Status.pluck(:selitetark, :selite)
    options_for_select statuses, params[:status]
  end

  def product_export_fields
    [
      [Product.human_attribute_name(:aleryhma),                      'aleryhma'],
      [Product.human_attribute_name(:alv),                           'alv'],
      [Product.human_attribute_name(:automaattinen_sarjanumerointi), 'automaattinen_sarjanumerointi'],
      [Product.human_attribute_name(:eankoodi),                      'eankoodi'],
      [Product.human_attribute_name(:ei_saldoa),                     'ei_saldoa'],
      [Product.human_attribute_name(:epakurantti100pvm),             'epakurantti100pvm'],
      [Product.human_attribute_name(:epakurantti25pvm),              'epakurantti25pvm'],
      [Product.human_attribute_name(:epakurantti50pvm),              'epakurantti50pvm'],
      [Product.human_attribute_name(:epakurantti75pvm),              'epakurantti75pvm'],
      [Product.human_attribute_name(:halytysraja),                   'halytysraja'],
      [Product.human_attribute_name(:hinnastoon),                    'hinnastoon'],
      [Product.human_attribute_name(:kehahin),                       'kehahin'],
      [Product.human_attribute_name(:kerayskommentti),               'kerayskommentti'],
      [Product.human_attribute_name(:keraysvyohyke),                 'keraysvyohyke'],
      [Product.human_attribute_name(:kohde),                         'kohde'],
      [Product.human_attribute_name(:kommentoitava),                 'kommentoitava'],
      [Product.human_attribute_name(:kuljetusohje),                  'kuljetusohje'],
      [Product.human_attribute_name(:kuluprosentti),                 'kuluprosentti'],
      [Product.human_attribute_name(:kustp),                         'kustp'],
      [Product.human_attribute_name(:kuvaus),                        'kuvaus'],
      [Product.human_attribute_name(:laatija),                       'laatija'],
      [Product.human_attribute_name(:leimahduspiste),                'leimahduspiste'],
      [Product.human_attribute_name(:luontiaika),                    'luontiaika'],
      [Product.human_attribute_name(:lyhytkuvaus),                   'lyhytkuvaus'],
      [Product.human_attribute_name(:mainosteksti),                  'mainosteksti'],
      [Product.human_attribute_name(:malli),                         'malli'],
      [Product.human_attribute_name(:mallitarkenne),                 'mallitarkenne'],
      [Product.human_attribute_name(:meria_saastuttava),             'meria_saastuttava'],
      [Product.human_attribute_name(:minimi_era),                    'minimi_era'],
      [Product.human_attribute_name(:muuta),                         'muuta'],
      [Product.human_attribute_name(:muutospvm),                     'muutospvm'],
      [Product.human_attribute_name(:muuttaja),                      'muuttaja'],
      [Product.human_attribute_name(:myyjanro),                      'myyjanro'],
      [Product.human_attribute_name(:myymalahinta),                  'myymalahinta'],
      [Product.human_attribute_name(:myynninseuranta),               'myynninseuranta'],
      [Product.human_attribute_name(:myynti_era),                    'myynti_era'],
      [Product.human_attribute_name(:myyntihinta),                   'myyntihinta'],
      [Product.human_attribute_name(:myyntihinta_maara),             'myyntihinta_maara'],
      [Product.human_attribute_name(:nakyvyys),                      'nakyvyys'],
      [Product.human_attribute_name(:nettohinta),                    'nettohinta'],
      [Product.human_attribute_name(:nimitys),                       'nimitys'],
      [Product.human_attribute_name(:osasto),                        'osasto'],
      [Product.human_attribute_name(:ostajanro),                     'ostajanro'],
      [Product.human_attribute_name(:ostoehdotus),                   'ostoehdotus'],
      [Product.human_attribute_name(:ostokommentti),                 'ostokommentti'],
      [Product.human_attribute_name(:pakkausmateriaali),             'pakkausmateriaali'],
      [Product.human_attribute_name(:panttitili),                    'panttitili'],
      [Product.human_attribute_name(:projekti),                      'projekti'],
      [Product.human_attribute_name(:purkukommentti),                'purkukommentti'],
      [Product.human_attribute_name(:sarjanumeroseuranta),           'sarjanumeroseuranta'],
      [Product.human_attribute_name(:status),                        'status'],
      [Product.human_attribute_name(:suoratoimitus),                 'suoratoimitus'],
      [Product.human_attribute_name(:tahtituote),                    'tahtituote'],
      [Product.human_attribute_name(:tarrakerroin),                  'tarrakerroin'],
      [Product.human_attribute_name(:tarrakpl),                      'tarrakpl'],
      [Product.human_attribute_name(:tilausmaara),                   'tilausmaara'],
      [Product.human_attribute_name(:tilausrivi_kommentti),          'tilausrivi_kommentti'],
      [Product.human_attribute_name(:tilino),                        'tilino'],
      [Product.human_attribute_name(:tilino_ei_eu),                  'tilino_ei_eu'],
      [Product.human_attribute_name(:tilino_eu),                     'tilino_eu'],
      [Product.human_attribute_name(:tilino_kaanteinen),             'tilino_kaanteinen'],
      [Product.human_attribute_name(:tilino_marginaali),             'tilino_marginaali'],
      [Product.human_attribute_name(:tilino_osto_marginaali),        'tilino_osto_marginaali'],
      [Product.human_attribute_name(:tilino_triang),                 'tilino_triang'],
      [Product.human_attribute_name(:toinenpaljous_muunnoskerroin),  'toinenpaljous_muunnoskerroin'],
      [Product.human_attribute_name(:try),                           'try'],
      [Product.human_attribute_name(:tullikohtelu),                  'tullikohtelu'],
      [Product.human_attribute_name(:tullinimike1),                  'tullinimike1'],
      [Product.human_attribute_name(:tullinimike2),                  'tullinimike2'],
      [Product.human_attribute_name(:tuotekorkeus),                  'tuotekorkeus'],
      [Product.human_attribute_name(:tuotekuva),                     'tuotekuva'],
      [Product.human_attribute_name(:tuoteleveys),                   'tuoteleveys'],
      [Product.human_attribute_name(:tuotemassa),                    'tuotemassa'],
      [Product.human_attribute_name(:tuotemerkki),                   'tuotemerkki'],
      [Product.human_attribute_name(:tuotepaallikko),                'tuotepaallikko'],
      [Product.human_attribute_name(:tuotesyvyys),                   'tuotesyvyys'],
      [Product.human_attribute_name(:tuotetyyppi),                   'tuotetyyppi'],
      [Product.human_attribute_name(:vak_imdg_koodi),                'vak_imdg_koodi'],
      [Product.human_attribute_name(:vakkoodi),                      'vakkoodi'],
      [Product.human_attribute_name(:vakmaara),                      'vakmaara'],
      [Product.human_attribute_name(:valmistusaika_sekunneissa),     'valmistusaika_sekunneissa'],
      [Product.human_attribute_name(:valmistuslinja),                'valmistuslinja'],
      [Product.human_attribute_name(:varmuus_varasto),               'varmuus_varasto'],
      [Product.human_attribute_name(:vienti),                        'vienti'],
      [Product.human_attribute_name(:vihahin),                       'vihahin'],
      [Product.human_attribute_name(:vihapvm),                       'vihapvm'],
      [Product.human_attribute_name(:yksikko),                       'yksikko'],
      [Product.human_attribute_name(:yksin_kerailyalustalle),        'yksin_kerailyalustalle'],
    ]
  end

  private

    def category_filter
      Product::Category.where(kieli: current_user.locale)
        .order(:jarjestys, :selite, :selitetark)
        .map { |c| ["#{c.tag} - #{c.description}", c.tag] }.uniq
    end

    def subcategory_filter
      Product::Subcategory.where(kieli: current_user.locale)
        .filter(categories: params[:osasto])
        .map { |c| ["#{c.tag} - #{c.description}", c.tag] }.uniq
    end

    def brand_filter
      Product::Brand.where(kieli: current_user.locale)
        .filter(categories: params[:osasto], subcategories: params[:try])
        .pluck(:name).uniq
    end
end
