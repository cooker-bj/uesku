CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAJHKHVQIHZJTSNQ3Q',                        # required
    :aws_secret_access_key  => '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'                        # required
  
                 # optional, defaults to 'us-east-1'
    # optional, defaults to nil
  }
  config.fog_directory  = 'myAmazon'
                      # required
    
end
