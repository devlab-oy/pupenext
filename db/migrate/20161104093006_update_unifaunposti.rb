class UpdateUnifaunposti < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      DeliveryMethod.where(virallinen_selite: ['ITELLAMAILEC','IT16','ITSP'])
        .update_all('virallinen_selite = \'PO2103\'')
      DeliveryMethod.where(virallinen_selite: ['IT21'])
        .update_all('virallinen_selite = \'PO2104\'')
      DeliveryMethod.where(virallinen_selite: ['IT14','ITVAK'])
        .update_all('virallinen_selite = \'PO2102\'')
      DeliveryMethod.where(virallinen_selite: ['IT09'])
        .update_all('virallinen_selite = \'PO2102_09\'')
      DeliveryMethod.where(virallinen_selite: ['ITEXPC'])
        .update_all('virallinen_selite = \'PO2102_00\'')
      DeliveryMethod.where(virallinen_selite: ['ITELLALOGKR'])
        .update_all('virallinen_selite = \'POF1\'')
      DeliveryMethod.where(virallinen_selite: ['ITKY14','ITKYVAK'])
        .update_all('virallinen_selite = \'PO2144\'')
      DeliveryMethod.where(virallinen_selite: ['ITKY09'])
        .update_all('virallinen_selite = \'PO2144_09\'')
      DeliveryMethod.where(virallinen_selite: ['ITKY21'])
        .update_all('virallinen_selite = \'PO2144_21\'')
      DeliveryMethod.where(virallinen_selite: ['ITKYEXPC'])
        .update_all('virallinen_selite = \'PO2144_00\'')
    end
  end
end
