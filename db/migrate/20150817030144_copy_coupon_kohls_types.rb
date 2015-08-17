class CopyCouponKohlsTypes < ActiveRecord::Migration
  class Coupon < ActiveRecord::Base
    has_and_belongs_to_many :kohls_types
    has_many :coupon_kohls_type_tmps
    has_many :kohls_types_tmp, :through => :coupon_kohls_type_tmps, :source => :kohls_type
  end
  
  class KohlsType < ActiveRecord::Base
    has_and_belongs_to_many :coupons
    has_many :coupon_kohls_type_tmps
    has_many :coupons_tmp, :through => :coupon_kohls_type_tmps, :source => :coupon
  end
  
  class CouponKohlsTypeTmp < ActiveRecord::Base
    belongs_to :coupon
    belongs_to :kohls_type
  end

  def up
    #require 'pry'; binding.pry
    Coupon.all.each do |coupon|
      coupon.kohls_types_tmp << coupon.kohls_types
    end
  end

  def down
  end
end
