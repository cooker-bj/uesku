Rails.application.config.middleware.use OmniAuth::Builder do
  provider :qq_connect, ENV['QQ_CONNECT_KEY'], ENV['QQ_CONNECT_SECRET']

end