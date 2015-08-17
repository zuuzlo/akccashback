class RenameCouponsKohlsTypeTmp < ActiveRecord::Migration
  def change
    rename_table :coupon_kohls_type_tmps, :coupon_kohls_types
  end
end
