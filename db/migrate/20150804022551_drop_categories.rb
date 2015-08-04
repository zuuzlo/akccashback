class DropCategories < ActiveRecord::Migration
  def change
    drop_table :categories
    drop_table :categories_coupons
  end
end
