class UpdateProductStatuses < ActiveRecord::Migration
  def change
    Company.all.each do |company|
      Current.company = company

      company.products.where(status: '').update_all(status: 'A')
    end
  end
end
