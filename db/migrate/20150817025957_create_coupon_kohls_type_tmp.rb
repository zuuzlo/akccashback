class CreateCouponKohlsTypeTmp < ActiveRecord::Migration
  def change
    create_table :coupon_kohls_type_tmps do |t|
      t.belongs_to :coupon, :null => false, :index => true
      t.belongs_to :kohls_type, :null => false, :index => true
    end
  end
end