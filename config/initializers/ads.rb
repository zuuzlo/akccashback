Ads.configure do |config|
  config.renderer = lambda { |options|
    tag(
      :img,
      src: "http://placehold.it/#{options[:width]}x#{options[:height]}&text=Adsense"
    )
  }
end
