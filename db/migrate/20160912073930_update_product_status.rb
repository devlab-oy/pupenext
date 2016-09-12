class UpdateProductStatus < ActiveRecord::Migration
  def up
    change_column_default :tuote, :status, 'A'

    Company.all.each do |company|
      Current.company = company

      company.product_statuses.where(tag: %w(A T E P)).delete_all
      company.products.where(status: '').update_all(status: 'A')
    end
  end

  def down
    change_column_default :tuote, :status, ''

    Company.all.each do |company|
      Current.company = company

      admin = User.find_by(kuka: :admin)
      Current.user = admin

      Product::Status.create! selite: 'A', selitetark: 'Aktiivi'
      Product::Status.create! selite: 'T', selitetark: 'Tilaustuote'
      Product::Status.create! selite: 'E', selitetark: 'Ehdokastuote'
      Product::Status.create! selite: 'P', selitetark: 'Poistettu'
    end
  end
end
