class CopyCouponsKohlsCategories < ActiveRecord::Migration
  class Coupon < ActiveRecord::Base
    has_and_belongs_to_many :kohls_categories
    has_many :coupon_kohls_category_tmps
    has_many :kohls_categories_tmp, :through => :coupon_kohls_category_tmps, :source => :kohls_category
  end
  
  class KohlsCategory < ActiveRecord::Base
    has_and_belongs_to_many :coupons
    has_many :coupon_kohls_category_tmps
    has_many :coupons_tmp, :through => :coupon_kohls_category_tmps, :source => :coupon
  end
  
  class CouponKohlsCategoryTmp < ActiveRecord::Base
    belongs_to :coupon
    belongs_to :kohls_category
  end

  def up
    #require 'pry'; binding.pry
    Coupon.all.each do |coupon|
      coupon.kohls_categories_tmp << coupon.kohls_categories
    end
  end

  def down
  end
end
