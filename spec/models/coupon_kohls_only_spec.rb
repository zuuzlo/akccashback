require 'spec_helper'

describe CouponKohlsOnly do
  it { should belong_to(:coupon) }
  it { should belong_to(:kohls_only) }

  it { should validate_presence_of(:coupon) }
  it { should validate_presence_of(:kohls_only) }
end