class AutomationScriptResultsController < InheritedResources::Base
  respond_to :js
  belongs_to :test_round
  
  def update_triage_result
    automation_script_result = AutomationScriptResult.find(params[:id])
    triage_result = params[:triage_result]
    respond_to do |format|
      if automation_script_result.update_triage!(triage_result)
        result = automation_script_result.test_round.send_triage_mail?
        if not result
          automation_script_result.test_round.update_result
          LongTasks.new.delay.send_triage_mail(automation_script_result.test_round) 
        end
        format.js { render :json => {:result => "success", :tr_result => automation_script_result.test_round.result, :asr_result => automation_script_result.result}}
      else
        format.js { render :json => {:result => "failed", :tr_result => automation_script_result.test_round.result, :asr_result => automation_script_result.result}}
      end
    end
  end
  
  def rerun
    automation_script_result_id = params[:id]
    automation_script_result = AutomationScriptResult.find(automation_script_result_id)
    automation_script_result.clear
    LongTasks.new.delay.rerun_automation_script_result_task(automation_script_result_id)
    render :nothing => true
  end
  
  protected
  def resource
    @test_round ||= TestRound.find(params[:test_round_id])
    @project = @test_round.project
    @automation_script_result ||= AutomationScriptResult.find(params[:id])
    @search = @automation_script_result.automation_case_results.search(params[:search])
    @automation_case_results = @search.page(params[:page]).per(15)
  end
  
  def collection
    @test_round ||= TestRound.find(params[:test_round_id])
    @search = @test_round.automation_script_results.order('id desc').search(params[:search])
    @automation_script_results ||= @search.page(params[:page]).per(15)
  end
end
