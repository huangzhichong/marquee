class NotificationMailer < ActionMailer::Base
  default :from => "MARQUEE <marquee@activenetwork.com>", :content_type => "text/html"

    def save_to_testlink_notification(email_address,message)    
    @message  = message
    mail(to: email_address, subject: 'Finish saving result to Testlink')
  end

end
