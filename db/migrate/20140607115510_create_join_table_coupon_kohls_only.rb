class CreateJoinTableCouponKohlsOnly < ActiveRecord::Migration
  def change
    create_join_table :coupons, :kohls_onlies do |t|
      t.index :coupon_id
      t.index :kohls_only_id
    end
  end
end
