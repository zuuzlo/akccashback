class DropCtypes < ActiveRecord::Migration
  def change
    drop_table :ctypes
    drop_table :coupons_ctypes
  end
end
