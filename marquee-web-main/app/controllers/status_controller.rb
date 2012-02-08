class StatusController < ApplicationController
  def new_build
    logger.info "New Build incoming. #{params}"
    ci_value = params[:project].split(/_|-/).map{|n| n.capitalize}.join('')
    env = params[:environment].gsub('Regression', 'QAR').gsub('INT-Latest', 'INT').gsub('P-INT', 'PINT')
    test_environment = TestEnvironment.find_by_value(env)
    test_object = "#{ci_value} #{params[:version]}"
    CiMapping.find_all_by_ci_value(ci_value).each do |ci_mapping|
      test_round = TestRound.create_for_new_build(ci_mapping.test_suite, ci_mapping.project, test_environment, User.automator, test_object)
      TestRoundDistributor.distribute(test_round)
    end
  end

  def update
    protocol = params[:protocol]
    what = protocol[:what]
    test_round_id = protocol[:round_id]
    test_round = TestRound.find(test_round_id)

    automation_script_result = test_round.find_automation_script_result_by_script_name(protocol[:data]['script_name'])
    if automation_script_result and not automation_script_result.end?
      case what
      when 'Script'
        update_automation_script(test_round, protocol[:data])
      when 'Case'
        update_automation_case(test_round, protocol[:data])
      end
    end
    render :nothing => true
  end

  protected
  def update_automation_script(test_round, data)
    if test_round.state != "completed"
      state = data['state'].downcase
      automation_script_result = test_round.find_automation_script_result_by_script_name(data['script_name'])
      if (state == 'start' && data['service'])
        automation_script_result.target_services.delete_all
        TargetService.create_services_for_automation_script_result(data['service'], automation_script_result)
      end
      automation_script_result.update_state!(state)
      test_round.update_state!
      if automation_script_result.end?
        automation_script_result.slave_assignments.each do |sa|
          sa.end!
          sa.slave.free! unless sa.slave.nil?
        end
      end
      if test_round.end?
        TestRoundMailer.finish_mail(test_round.id).deliver
      end
    end
  end

  def update_automation_case(test_round, data)
    script_name = data['script_name']
    screen_shot_name = data["screen_shot"]

    automation_script = test_round.find_automation_scirpt_by_script_name(script_name)
    automation_script_result = test_round.find_automation_script_result_by_script_name(script_name)
    automation_case = automation_script.find_case_by_case_id(data['case_id'])
    automation_case_result = automation_script_result.find_case_result_by_case_id(automation_case.id)
    automation_case_result.screen_shot = screen_shot_name
    automation_case_result.server_log = data['server_log'] unless data['server_log'].nil?
    automation_case_result.update!(data)
    automation_case_result.save!

    automation_script_result.update_counters_by_case_result!(automation_case_result)
    test_round.update_counters_by_case_result!(automation_case_result)
  end
end
