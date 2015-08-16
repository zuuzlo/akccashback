class CopyCouponKohlsOnlies < ActiveRecord::Migration
  class Coupon < ActiveRecord::Base
    has_and_belongs_to_many :kohls_onlies
    has_many :coupon_kohls_only_tmps
    has_many :kohls_onlies_tmp, :through => :coupon_kohls_only_tmps, :source => :kohls_only
  end
  
  class KohlsCategory < ActiveRecord::Base
    has_and_belongs_to_many :coupons
    has_many :coupon_kohls_only_tmps
    has_many :coupons_tmp, :through => :coupon_kohls_only_tmps, :source => :coupon
  end
  
  class CouponKohlsOnlyTmp < ActiveRecord::Base
    belongs_to :coupon
    belongs_to :kohls_only
  end

  def up
    Coupon.all.each do |coupon|
      coupon.kohls_onlies_tmp << coupon.kohls_onlies
    end
  end

  def down
  end
end
