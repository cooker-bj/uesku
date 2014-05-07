CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAJHKHVQIHZJTSNQ3Q',                        # required
    :aws_secret_access_key  => 'gd7VWwjcLasywTPYvYzy5ZxwKodRT6xetSXZH9Us',                        # required
    :region                 => 'singapore',
    :host                   => 's3.example.com',             # optional, defaults to nil
    :endpoint               => 'https://s3.example.com:8080'                 # optional, defaults to 'us-east-1'
    # optional, defaults to nil
  }
  config.fog_directory  = 'uesku'
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}                     # required
    
end
