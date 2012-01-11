class TimecardMailer < ActionMailer::Base
  default :from => "Oracle Timecard Reminder <oracle.timecard.reminder@active.com>", :content_type => "text/html"

  def remind_mail(to, start_date, time_cards)
    @time_cards = time_cards
    @start_date = start_date
    mail(:to => to,
         :subject => "Please submit missing timecard for #{@start_date.year} - #{@start_date.month} !!!").deliver
  end

  def summary_email(to, start_date, time_cards)
    @time_cards = time_cards
    @start_date = start_date

    mail(:to => to,
         :subject => "Summary of your team's Oracle Time Cards for #{@start_date.year} - #{@start_date.month}").deliver
  end

end
