Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(:recaptcha, :public_key)
  config.secret_key = Rails.application.credentials.dig(:recaptcha, :private_key)
end
