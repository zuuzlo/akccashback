class Coupon < ActiveRecord::Base

  require 'action_view'
  include ActionView::Helpers::DateHelper

  NULL_ATTRS = %w( code restriction )
  before_save :nil_if_blank

  belongs_to :store
  has_and_belongs_to_many :categories, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :kohls_categories, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :kohls_onlies, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :kohls_types, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :ctypes, after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :users
  
  validates :id_of_coupon, presence: true, uniqueness: true
  validates :title, presence: true
  validates :link, presence: true

  mount_uploader :image, CouponImageUploader

  def touch_updated_at(object)
    self.touch if persisted?
  end

  def time_left
    distance_of_time_in_words(end_date, DateTime.now)
  end

  def time_difference
    end_date - DateTime.now
  end

  def store_name
    Store.find(self.store_id).name
  end

  def store_image
    Store.find(self.store_id).store_img
  end

  def store_commission
    Store.find(self.store_id).commission / 2
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("lower(description) LIKE ?", "%#{search_term.downcase}%")
  end

  def preview?
    if start_date > DateTime.now
      true
    end
  end

  def time_til_good
    distance_of_time_in_words(start_date, DateTime.now)
  end

  protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end
end