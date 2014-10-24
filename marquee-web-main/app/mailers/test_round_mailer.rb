class TestRoundMailer < AsyncMailer
  default :from => "MARQUEE <marquee@activenetwork.com>", :content_type => "text/html"
  # send email to creator and script owners when test round is finished.
  def finish_mail(test_round_id)
    @test_round = TestRound.find(test_round_id)
    @project = @test_round.project

    subject = "[#{@project} #{@test_round.test_suite.test_type.name}##{@test_round.id} on #{@test_round.test_environment.name}] #{@test_round.result} : for testing #{@test_round.test_object}"
    
    mail_to = [@test_round.creator.email]
    mail_to << @test_round.owner_emails
    mail_to = mail_to.join(',')
    send_mail(mail_to, subject)
  end

  def notify_mail(test_round_id,reveivers)
    @test_round = TestRound.find(test_round_id)
    @project = @test_round.project

    @test_services = @test_round.automation_script_results.collect{|asr| asr.target_services}.flatten.join(', ')
    subject = "[Report for #{@project} #{@test_round.test_suite.test_type.name}##{@test_round.id} on #{@test_round.test_environment.name} ] #{@test_round.result} : for testing #{@test_round.test_object}"
    puts "=======>>>>>>>> send email to #{reveivers}"
    send_mail(reveivers, subject)
  end

  protected
  def send_mail(to, subject)
    logger.info "send mail to #{to}, with subject: #{subject}"
    mail(:to => to,
         :subject => subject
         ) unless to.empty?
  end

end
