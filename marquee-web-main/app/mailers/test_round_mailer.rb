class TestRoundMailer < AsyncMailer
  default :from => "MARQUEE <marquee@active.com>", :content_type => "text/html"

  def finish_mail(test_round)
    @project = test_round.project
    @test_round = test_round
    subject = "[#{@project} #{@test_round.test_suite.test_type.name}##{@test_round.id} on #{@test_round.test_environment.name}] #{@test_round.result} : for testing #{@test_round.test_object}"
    mail_notify_group = MailNotifyGroup.where(:name => 'test_round_finish').first

    mail_to = @project.mail_notify_settings.find_all{|mns|mns.mail_notify_groups.include?(mail_notify_group) && mns.test_types.include?(@test_round.test_type)}

    if test_round.result == 'pass'
      extra_mail_notify_group = MailNotifyGroup.where(:name => 'test_round_triaged').first
      extra_mail_to = @project.mail_notify_settings.find_all{|mns|mns.mail_notify_groups.include?(extra_mail_notify_group) && mns.test_types.include?(@test_round.test_type)}
      mail_to = mail_to | extra_mail_to
    end

    mail_to = mail_to.map(&:mail).join(',')

    logger.warn "There's no mail notify settings for #{@test_round.market.name} on Test Type #{@test_round.test_suite.test_type.name}" if mail_to.empty?
    send_mail(mail_to, subject)
  end

  def triage_mail(test_round)
    @project = test_round.project
    @test_round = test_round
    @test_services = @test_round.automation_script_results.collect{|asr| asr.target_services}.flatten.join(', ')
    subject = "[Triaged #{@project} #{@test_round.test_suite.test_type.name}##{@test_round.id} on #{@test_round.test_environment.name} ] #{@test_round.result} : for testing #{@test_round.test_object}"
    mail_notify_group = MailNotifyGroup.where(:name => 'test_round_triaged').first

    mail_to = @project.mail_notify_settings.find_all{|mns|mns.mail_notify_groups.include?(mail_notify_group) && mns.test_types.include?(@test_round.test_type)}.map(&:mail).join(',')
    send_mail(mail_to, subject)
  end

  protected
  def send_mail(to, subject)
    logger.info "send mail to #{to}, with subject: #{subject}"
    mail(:to => to,
         :subject => subject
         ) unless to.empty?
  end

end
