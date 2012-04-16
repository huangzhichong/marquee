ActionMailer::Base.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :openssl_verify_mode => "none"
}
