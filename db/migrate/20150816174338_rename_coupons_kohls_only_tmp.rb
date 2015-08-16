class RenameCouponsKohlsOnlyTmp < ActiveRecord::Migration
  def change
    rename_table :coupon_kohls_only_tmps, :coupon_kohls_onlies
  end
end
