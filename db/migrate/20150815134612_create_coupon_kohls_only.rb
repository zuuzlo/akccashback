class CreateCouponKohlsOnly < ActiveRecord::Migration
  def change
    create_table :coupon_kohls_only_tmps do |t|
      t.belongs_to :coupon, :null => false, :index => true
      t.belongs_to :kohls_only, :null => false, :index => true
    end
  end
end
