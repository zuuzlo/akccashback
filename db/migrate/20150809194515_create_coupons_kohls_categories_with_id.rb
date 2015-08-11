class CreateCouponsKohlsCategoriesWithId < ActiveRecord::Migration
  def change
    create_table :coupon_kohls_category_tmps do |t|
      t.belongs_to :coupon, :null => false, :index => true
      t.belongs_to :kohls_category, :null => false, :index => true
    end
  end
end