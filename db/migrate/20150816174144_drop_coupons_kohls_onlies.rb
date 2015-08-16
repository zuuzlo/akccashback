class DropCouponsKohlsOnlies < ActiveRecord::Migration
  def change
    drop_table :coupons_kohls_onlies
  end
end
