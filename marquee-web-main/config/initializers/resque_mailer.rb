Resque::Mailer.default_queue_name = "marquee_mailer"
class AsyncMailer < ActionMailer::Base
  include Resque::Mailer
end

Resque::Mailer.excluded_environments = []
