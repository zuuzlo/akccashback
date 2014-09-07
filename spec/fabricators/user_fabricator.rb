Fabricator(:user) do
  email { Faker::Internet.email }
  user_name { Faker::Lorem.word }
  password 'password'
  password_confirmation 'password'
  full_name { Faker::Name.name }
  terms { true }
end