CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  }
  
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  elsif Rails.env.development?
    config.storage = :fog
    config.fog_directory = 'testcashbackakc'
  else
    config.storage = :fog
    config.fog_directory = 'cashbackakc'
  end
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_attributes = { 'Cache-Control'=>"max-age=#{365.day.to_i}" }
end