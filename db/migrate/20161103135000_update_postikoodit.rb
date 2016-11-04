class UpdatePostikoodit < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Economy 16'")
        .update_all('virallinen_selite = \'Postipaketti\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Flex 21'")
        .where("toimitustapa.kuljyksikko = 'o'")
        .update_all('virallinen_selite = \'Express-rahti Illaksi 21\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Flex 21'")
        .update_all('virallinen_selite = \'Kotipaketti\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Business Day 14'")
        .where("toimitustapa.kuljyksikko = 'o'")
        .update_all('virallinen_selite = \'Express-rahti\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Business Day 14'")
        .update_all('virallinen_selite = \'Express-paketti\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Morning 9'")
        .update_all('virallinen_selite = \'Express-paketti Aamuksi 09\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express City 00'")
        .update_all('virallinen_selite = \'Express-paketti Samana Päivänä 00\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express Morning 9'")
        .update_all('virallinen_selite = \'Express-paketti Aamuksi 09\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Express City 00'")
        .update_all('virallinen_selite = \'Express-paketti Samana Päivänä 00\'')
      DeliveryMethod.where("toimitustapa.virallinen_selite = 'Priority Ulkomaa'")
        .update_all('virallinen_selite = \'Priority\'')
    end
  end
end
