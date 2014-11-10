Fog.mock!

Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
connection = Fog::Storage.new(:provider => 'AWS',
   aws_access_key_id: Figaro.env.aws_access_key_id,
aws_secret_access_key: Figaro.env.aws_secret_access_key)
connection.directories.create(:key => 'cashbackakc')