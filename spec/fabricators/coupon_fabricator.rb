Fabricator(:coupon) do
  id_of_coupon { Faker::Number.number(5) }
  title { Faker::Lorem.sentence(word_count = 3) }
  description { Faker::Lorem.sentence(word_count = 5) }
  start_date { Time.now - 3.day }
  end_date { Time.now + 3.day }
  code { Faker::Lorem.word }
  restriction { Faker::Lorem.sentence( word_count = 5 ) }
  link { Faker::Internet.url }
  #image { "holder.js/100%x180" }

  image {
    Rack::Test::UploadedFile.new(
      "./spec/support/files/1322715.jpeg",
      "image/jpeg"
    )
  }
  
  coupon_source_id { 1 }
end