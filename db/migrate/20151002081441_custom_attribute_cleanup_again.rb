class CustomAttributeCleanupAgain < ActiveRecord::Migration
  def change
    Company.find_each do |company|
      Current.company = company.yhtio
      Keyword::CustomAttribute.where(set_name: '').delete_all
    end
  end
end
