require 'spec_helper'

describe CouponKohlsCategory do
  it { should belong_to(:coupon) }
  it { should belong_to(:kohls_category) }

  it { should validate_presence_of(:coupon) }
  it { should validate_presence_of(:kohls_category) }
end