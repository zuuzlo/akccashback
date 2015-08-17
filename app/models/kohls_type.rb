class KohlsType < ActiveRecord::Base

  has_many :coupon_kohls_types
  has_many :coupons, :through => :coupon_kohls_types
  
  #has_and_belongs_to_many :coupons, -> { order "end_date ASC" }
  validates :name, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.with_coupons
    KohlsType.joins(:coupons).where(["end_date >= :time", { :time => DateTime.current }]).uniq.order( 'name ASC' )
  end
end
