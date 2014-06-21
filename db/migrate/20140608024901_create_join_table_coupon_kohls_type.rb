class CreateJoinTableCouponKohlsType < ActiveRecord::Migration
  def change
    create_join_table :coupons, :kohls_types do |t|
      t.index :coupon_id
      t.index :kohls_type_id
    end
  end
end
