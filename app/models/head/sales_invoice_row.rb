class Head::SalesInvoiceRow < BaseModel

  belongs_to :invoice, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoice'
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno
  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Order'

  default_scope { where(tyyppi: 'L') }
  default_scope { where.not(var: %w(P J O S)) }

  self.table_name = :tilausrivi
  self.primary_key = :tunnus

  def delivery_date
    if (company.parameter.manual_deliverydates_for_all_products? ||
      (company.parameter.manual_deliverydates_when_product_inventory_not_managed? &&
        product.no_inventory_management?)) &&
      toimaika
      toimaika
    elsif toimitettuaika
      toimitettuaika.to_date
    else
      laskutettuaika
    end
  end

  def invoice_comment

    ic = kommentti

    if company.parameter.myynnin_alekentat > 1 || erikoisale > 0

      alekomm = ""

      company.parameter.myynnin_alekentat.times do |i|
        if send("ale#{i+1}") > 0
          alekomm = "#{alekomm} Ale#{i+1} #{send("ale#{i+1}")}%\n"
        end
      end

      if erikoisale > 0
        alekomm = "#{alekomm} Erikoisale #{erikoisale}%\n"
      end

      ic = "#{alekomm}#{ic}"
    end

    if reverse_charge
      ic = "#{ic} Ei lisättyä arvonlisäveroa, ostajan käännetty verovelvollisuus."
    end

    if exempt_for_resale
      ic = "#{ic} Ei sisällä vähennettävää veroa."
    end

    #    //Hetaan sarjanumeron tiedot
    #    if ($tilrow["kpl"] > 0) {
    #      $sarjanutunnus = "myyntirivitunnus";
    #    }
    #    else {
    #      $sarjanutunnus = "ostorivitunnus";
    #    }
    #
    #    $query = "SELECT *
    #              FROM sarjanumeroseuranta
    #              WHERE yhtio      = '$kukarow[yhtio]'
    #              and tuoteno      = '$tilrow[tuoteno]'
    #              and $sarjanutunnus in ($tilrow[rivitunnukset])
    #              and sarjanumero != ''";
    #    $sarjares = pupe_query($query);
    #
    #    if ($tilrow["kommentti"] != '' and mysql_num_rows($sarjares) > 0) {
    #      $tilrow["kommentti"] .= " ";
    #    }
    #    while ($sarjarow = mysql_fetch_assoc($sarjares)) {
    #      $tilrow["kommentti"] .= "S:nro: $sarjarow[sarjanumero] ";
    #    }
    #
    #    if ($laskutyyppi == 7) {
    #
    #      if ($tilrow["eankoodi"] != "") {
    #        $tilrow["kommentti"] = "EAN: $tilrow[eankoodi]|$tilrow[kommentti]";
    #      }
    #
    #      $query = "SELECT kommentti
    #                FROM asiakaskommentti
    #                WHERE yhtio = '{$kukarow['yhtio']}'
    #                AND tuoteno = '{$tilrow['tuoteno']}'
    #                AND ytunnus = '{$lasrow['ytunnus']}'
    #                ORDER BY tunnus";
    #      $asiakaskommentti_res = pupe_query($query);
    #
    #      if (mysql_num_rows($asiakaskommentti_res) > 0) {
    #        while ($asiakaskommentti_row = mysql_fetch_assoc($asiakaskommentti_res)) {
    #          $tilrow["kommentti"] .= "|".$asiakaskommentti_row['kommentti'];
    #        }
    #      }
    #    }

    if order.asiakkaan_tilausnumero.present?
      ic = "#{ic} Asiakkaan tilausnumero: #{order.asiakkaan_tilausnumero}"
    end

    lisakomm = ""

    if tuoteno != company.parameter.kuljetusvakuutus_tuotenumero &&
       tuoteno != company.parameter.laskutuslisa_tuotenumero
       # && tilrow['seuraava_otunnus'] != $tilrow["otunnus"]

      if order.viesti.present?
        lisakomm = "#{lisakomm} #{order.viesti}"
      end

      #     # Tämä on tilauksen vika rivi, laitetaan työmäärystiedot tähän
      #     $query = "SELECT tyomaarays.*
      #               FROM lasku
      #               JOIN tyomaarays ON lasku.yhtio=tyomaarays.yhtio and lasku.tunnus=tyomaarays.otunnus
      #               WHERE lasku.yhtio      = '$kukarow[yhtio]'
      #               and lasku.tilaustyyppi = 'A'
      #               and lasku.tunnus       = '$tilrow[otunnus]'";
      #     $tyomres = pupe_query($query);

      #     if (mysql_num_rows($tyomres) > 0) {
      #      while ($tyomrow = mysql_fetch_assoc($tyomres)) {
      #        $lisakomm .= "|".t("Työmääräys", $kieli). ": $tyomrow[otunnus]";
      #        $al_res = t_avainsana("TYOM_TYOKENTAT", $kieli, "and avainsana.selitetark != '' and avainsana.nakyvyys in ('K','L')");
      #        while ($al_row = mysql_fetch_assoc($al_res)) {
      #          $kentta = $al_row["selite"];
      #          if (((!is_numeric($tyomrow[$kentta]) and trim($tyomrow[$kentta]) != '') or (is_numeric($tyomrow[$kentta]) and $tyomrow[$kentta] != 0)) and trim($tyomrow[$kentta]) != '0000-00-00') {
      #            if (strtoupper($al_row["selitetark_2"]) == "TEXT") {
      #              $lisakomm .= "|$al_row[selitetark]: ".$tyomrow[$kentta];
      #            }
      #            else {
      #              if (strtoupper($al_row["selitetark_2"]) == "DATE") {
      #                $tyomrow[$kentta] = tv1dateconv($tyomrow[$kentta]);
      #              }
      #              elseif ($kentta == "suorittaja") {
      #                $query = "SELECT nimi
      #                          FROM kuka
      #                          WHERE yhtio = '$kukarow[yhtio]'
      #                          and kuka    = '".$tyomrow[$kentta]."'";
      #                $yresult = pupe_query($query);
      #                $row = mysql_fetch_assoc($yresult);
      #                $tyomrow[$kentta] = $row["nimi"];
      #              }
      #              elseif ($kentta == "merkki") {
      #                $yresult = t_avainsana("SARJANUMERON_LI", $kieli, "and avainsana.selite = 'MERKKI' and avainsana.selitetark = '".$tyomrow[$kentta]."'");
      #                if (mysql_num_rows($yresult) > 0) {
      #                  $row = mysql_fetch_assoc($yresult);
      #                  $tyomrow[$kentta] = $row["selitetark_2"];
      #                }
      #              }
      #              $lisakomm .= "|$al_row[selitetark]: ".$tyomrow[$kentta];
      #            }
      #          }
      #        }
      #      }
      #    }
      #  }
    end

    "#{lisakomm}\n#{ic}".strip
  end

  def hinta_valuutassa
    invoice.foreign_currency ? hinta / order.vienti_kurssi : hinta
  end

  def rivihinta_valuutassa
    invoice.foreign_currency ? read_attribute(:rivihinta_valuutassa) : rivihinta
  end

  def rivihinta_verollinen
    deduct_discount(add_tax(hinta * kpl))
  end

  def rivihinta_valuutassa_verollinen
    deduct_discount(add_tax(hinta_valuutassa * kpl))
  end

  def total_discount
    discount = 1

    company.parameter.myynnin_alekentat.times do |i|
      discount = discount * (1 - send("ale#{i+1}") / 100)
    end

    discount = discount * (1 - erikoisale / 100)
    discount = ((1 - discount) * 100).round(2)
  end

  def reverse_charge
    alv >= 600
  end

  def exempt_for_resale
    alv >= 500 && alv < 600
  end

  def vat_amount
    rivihinta_valuutassa*vat_percent/100.round(2)
  end

  def vat_percent
    if alv >= 500
      0.0.to_d
    else
      alv
    end
  end

  def vat_code(vat_rate)
    if vat_rate >= 600
      "AE" # VAT Reverse Charge
    elsif vat_rate >= 500
      "AB" # Exempt for resale
    elsif vienti == "E"
      "E" # Exempt from tax
    elsif vienti == "K"
      "G" # Free export item, tax not charged
    else
      "S" # Standard rate
    end
  end

  private
    def add_tax(price)
      if company.parameter.price_excl_tax?
        price * (1 + vat_percent / 100)
      else
        price
      end
    end

    def deduct_discount(price)
      company.parameter.myynnin_alekentat.times do |i|
        price = price * (1 - send("ale#{i+1}") / 100)
      end

      price
    end
end
