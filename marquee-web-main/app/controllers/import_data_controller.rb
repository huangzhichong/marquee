class ImportDataController < ApplicationController
  def import_automation_script
    script = params[:data]["automation_script"]
    cases = params[:data]["automation_cases"]
    p = Project.find_by_name(script["project"])
    owner_id = User.find_or_create_default_by_email(script["owner"].downcase).id
    tp = p.test_plans.find_by_name(script["plan_name"])
    if tp !=nil
      as = tp.automation_scripts.find_or_create_by_name(script["script_name"])
      as.status = script["status"]
      as.version = "1.0"
      as.project_id = p.id
      as.owner_id = owner_id
      as.automation_driver_id  = AutomationDriver.find_or_create_by_name(script["auto_driver"]).id
      as.time_out_limit = script["timeout"]
      case_array = ([]<<cases["case_id"]).flatten
      case_array.each do |c|
        tc = tp.test_cases.find_by_case_id(c)
        if tc != nil
          ac = as.automation_cases.find_or_create_by_case_id(tc.case_id)
          ac.name = tc.name
          ac.priority = tc.priority
          ac.version = "1.0"
          ac.save
        end
      end
      as.save
    end
  end
  def import_as_and_tc_status
    script = params[:data]["automation_script"]
    cases = params[:data]["automation_cases"]
    p = Project.find_by_name(script["project"])
    owner_id = User.find_or_create_default_by_email(script["owner"].downcase).id
    tp = p.test_plans.find_by_name(script["plan_name"])
    if tp !=nil
      as = tp.automation_scripts.find_or_create_by_name(script["script_name"])
      as.status = script["status"]
      as.version = "1.0"
      as.project_id = p.id
      as.owner_id = owner_id
      as.automation_driver_id  = AutomationDriver.find_or_create_by_name(script["auto_driver"]).id
      as.time_out_limit = script["timeout"]
      case_array = ([]<<cases["case_id"]).flatten
      case_array.each do |c|
        tc = tp.test_cases.find_by_case_id(c)
        if tc != nil
          tc.automated_status = "Automated"
          tc.save
          ac = as.automation_cases.find_or_create_by_case_id(tc.case_id)
          ac.name = tc.name
          ac.priority = tc.priority
          ac.version = "1.0"
          ac.save
        end
      end
      as.save
    end
  end
  def import_script_without_test_plan
    script = params[:data]["automation_script"]
    cases = params[:data]["automation_cases"]
    p = Project.find_by_name(script["project"])
    if p != nil
      tp = p.test_plans.find_or_create_by_name(script["name"])
      tp.status = script["status"]
      tp.version = "1.0"
      tp.save
      as = tp.automation_scripts.find_or_create_by_name(script["name"])
      as.status = script["status"]
      as.version = "1.0"
      as.project_id = p.id
      as.owner_id = User.find_or_create_default_by_email(script["owner"]).id
      as.automation_driver_id  = AutomationDriver.find_or_create_by_name(script["auto_driver"]).id
      as.time_out_limit = script["timeout"]
      as.save
      info_array = ([]<<cases["case_info"]).flatten
      info_array.each do |c|
        tc = tp.test_cases.find_or_create_by_case_id(c.split('##').first)
        tc.name = c.split('##').last
        tc.version = "1.0"
        tc.priority = "P1"
        tc.automated_status = "Automated"
        tc.save
        ac = as.automation_cases.find_or_create_by_case_id(tc.case_id)
        ac.name = tc.name
        ac.priority = tc.priority
        ac.version = "1.0"
        ac.save
      end
    end
  end

  def import_test_plan_from_xml
    p = Project.find_by_name(params[:data]['project_name'])
    if p != nil
      test_plan =params[:data]['test_plan']
      tp = p.test_plans.find_or_create_by_name(test_plan['name'])
      tp.status = test_plan['status']
      tp.version = test_plan['version']
      tp.plan_type = test_plan['type']
      tp.project_id = p.id
      tp.save
      case_array =  ([]<<params[:data]["test_case"]).flatten
      case_array.each do |case_info|
        tc = tp.test_cases.find_or_create_by_case_id(case_info['case_id'])
        tc.name = case_info['name']
        tc.priority = case_info['priority']
        tc.automated_status = case_info['automated_status']
        tc.version = case_info['version']
        tc.test_plan_id = tp.id
        tc.save
        step_array = (([]<<case_info["test_step"]).flatten)
        step_array.each do |step_info|
          ts = tc.tc_steps.find_or_create_by_step_number(step_info['order_number'])
          ts.step_action = step_info['step']
          ts.expected_result = step_info['expected_result']
          ts.test_case_id = tc.id
          ts.save
        end
      end
    end
  end

  def refresh_testlink_data
    project_mappings = []
    project_mappings << {"marquee_project" => 'Camps',"testlink_project"  => 'Camps'}
    project_mappings << {"marquee_project" => 'Endurance',"testlink_project"  => 'Endurance'}
    project_mappings << {"marquee_project" => 'Giving',"testlink_project"  => 'Giving'}
    project_mappings << {"marquee_project" => 'Backoffice',"testlink_project"  => 'Backoffice'}
    project_mappings << {"marquee_project" => 'Sports',"testlink_project"  => 'Sports'}
    project_mappings << {"marquee_project" => 'Membership',"testlink_project"  => 'Membership'}
    project_mappings << {"marquee_project" => 'UsableNet',"testlink_project"  => 'UsableNet'}
    project_mappings << {"marquee_project" => 'iPhoneApp',"testlink_project"  => 'ActiveiPhoneApp'}
    project_mappings << {"marquee_project" => 'PaoBuKong',"testlink_project"  => 'PaoBuKong'}

    project_mappings.each do |mapping|
      marquee_project_name = mapping["marquee_project"]
      project_name = mapping["testlink_project"]
      mp = Project.find_by_name(marquee_project_name)
      get_project_by_name = "select id,name from old_projects where name ='#{project_name}'"
      if !mp.nil?
        local_projects = LocalTestlink.connection.execute(get_project_by_name)
        local_projects.each do |p|
          logger.info "======>>> #{p[1]} in TestLink ======>>> will import to #{mp.name} in Marquee"
          mp.test_plans.all.each do |mtp|
            mtp.status = 'expired'
            mtp.save
          end
          get_tp_query = "select * from old_test_plans where project_id = '#{p[0]}' limit 9999999"
          local_test_plans = LocalTestlink.connection.execute(get_tp_query)
          local_test_plans.each do |tp|
            mtp = mp.test_plans.find_or_create_by_name(tp[2].strip.gsub(/\s+/,' '))
            mtp.status = "completed"
            mtp.version = tp[3]
            mtp.plan_type = tp[5]
            mtp.save
            get_tc_query = "select * from old_test_cases where test_plan_id = '#{tp[0]}' limit 9999999"
            local_test_cases = LocalTestlink.connection.execute(get_tc_query)
            local_test_cases.each do |tc|
              mtc = mtp.test_cases.find_or_create_by_case_id(tc[3])
              mtc.tc_steps.delete_all
              mtc.name = tc[2].strip
              mtc.version = tc[4]
              mtc.priority = "P#{4-tc[5]}"
              mtc.automated_status = tc[6]
              mtc.test_link_id = tc[7]
              mtc.save
            end
          end
          logger.info "======>>>done the import for #{mp.name}"
        end
      end
    end
    TcStep.delete_all
    get_test_steps = ("
    select ts.step_number as step_number,
    ts.action as step_action,
    ts.expected_result as expected_result,
    tc.case_id as test_case_id,
    ts.test_link_id as test_link_id
    from old_test_steps ts
    join old_test_cases tc on tc.id = ts.test_case_id
    limit 99999999
    ")
    old_test_steps = LocalTestlink.connection.execute(get_test_steps)
    old_test_steps.each do |ts|
      ts[3] = TestCase.where(:case_id =>ts[3]).first['id'] if TestCase.where(:case_id =>ts[3]).first != nil
      ts = ts.collect{ |d| "'" + d.to_s.gsub("'","").gsub("\"","") + "'" }.join(",")
        ActiveRecord::Base.connection.insert("INSERT INTO tc_steps (step_number,step_action,expected_result,test_case_id,test_link_id) VALUES (#{ts})")
      end
    end
  end
