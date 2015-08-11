class DropCouponsKohlsCategories < ActiveRecord::Migration
  def change
    drop_table :coupons_kohls_categories
  end
end
