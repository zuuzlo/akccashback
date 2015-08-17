class DropCouponsKohlsTypes < ActiveRecord::Migration
  def change
    drop_table :coupons_kohls_types
  end
end