require 'csv'
class TestRoundsController < InheritedResources::Base
  respond_to :js
  respond_to :csv
  belongs_to :project
  before_filter :authenticate_user!, :only => [:new, :crete]

  def config_notify_email
    @test_round = TestRound.find(params[:test_round_id])
    @notification_emails = @test_round.notification_emails
    respond_to do |format|
      format.html { render :layout => false}
      format.js { render :layout => false}
    end
  end
  def send_notify_email
    @test_round = TestRound.find(params[:test_round_id])
    @notification_emails = params[:notify_emails]

    respond_to do |format|
      unless @notification_emails.empty?
        unless @notification_emails.split(',').any?{|email| not_a_valid_email?(email.strip)}
          TestRoundMailer.notify_mail(@test_round.id,@notification_emails).deliver
        else
          flash[:notice] = "there is invalid email address, please check."
        end
        format.js { render :layout => false}
      else
        flash[:notice] = "please select or enter email address."
        format.js { render :layout => false}
      end
    end
  end
  def rerun_failed
    test_round = TestRound.find(params[:test_round_id])
    test_round.automation_script_results.where("result != 'pass' and triage_result ='N/A'").each do |asr|
      asr.clear
      non_rerunned_asr = asr.test_round.automation_script_results.select {|asr| asr.state != "scheduling"}
      if non_rerunned_asr.nil? || non_rerunned_asr.empty?
        asr.test_round.start_time = nil
        asr.test_round.save
      end
      AutomationScriptResultRunner.rerun(asr.id)
    end
    render :nothing => true
  end
  def rerun
    test_round = TestRound.find(params[:test_round_id])
    test_round.automation_script_results.each do |asr|
      asr.clear
      non_rerunned_asr = asr.test_round.automation_script_results.select {|asr| asr.state != "scheduling"}
      if non_rerunned_asr.nil? || non_rerunned_asr.empty?
        asr.test_round.start_time = nil
        asr.test_round.save
      end
      AutomationScriptResultRunner.rerun(asr.id)
    end
    render :nothing => true
  end

  def create
    create! do
      @test_round.set_default_value
      @test_round.save
      # AutomationScriptResultsInitializer.createAutomationScriptResults(@test_round.id)
      TestRoundDistributor.distribute(@test_round.id)
      project_test_rounds_path(@project)
    end
  end

  def save_to_testlink
    SaveResultToTestlink.save(params[:test_round_id],params[:dev_key],params[:project_name],params[:test_plan_name],params[:build_name],params[:platform_name],params[:email])
    render :nothing => true
  end

  def execute_multiple_site
    ActivenetMultipleSiteDistributor.distribute(params)
    redirect_to project_test_rounds_path(Project.find_by_name('ActiveNet'))
  end

  protected
  def resource
    @project ||= Project.find(params[:project_id])
    @test_round ||= TestRound.find(params[:id])
    @search = @test_round.automation_script_results.search(params[:search])
    @automation_script_results = @search.order('id desc').page(params[:page]).per(15)
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.test_rounds.search(params[:search])
    @test_rounds ||= @search.order('id desc').page(params[:page]).per(15)
  end
  private
  def not_a_valid_email?(email)
    (email =~ /\A([\S].?)+@(activenetwork|active)\.com\z/i).nil?
  end

end
