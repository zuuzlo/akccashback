class CreateJoinTableCouponKohlsCategory < ActiveRecord::Migration
  def change
    create_join_table :coupons, :kohls_categories do |t|
      t.index :coupon_id
      t.index :kohls_category_id
    end
  end
end
