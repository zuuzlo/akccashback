# encoding: utf-8

class CouponImageUploader < CarrierWave::Uploader::Base

  
  include CarrierWave::RMagick
  
  #storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    '/tmp/cashbackakc-image_cache'
  end

  process :resize_to_fill => [125, 125]
end
