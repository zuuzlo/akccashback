class RenameCouponsKohlsCategoriesTmp < ActiveRecord::Migration
  def change
    rename_table :coupon_kohls_category_tmps, :coupon_kohls_categories
  end
end
