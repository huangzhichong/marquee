require 'xmlrpc/client'
class TestlinkAPIClient
  # substitute your server URL Here
  SERVER_URL = "http://10.109.0.164/testlink/lib/api/xmlrpc.php"

  def initialize(dev_key)
    @server = XMLRPC::Client.new2(SERVER_URL)
    @devKey = dev_key
  end

  def check_dev_key
    @server.call("tl.checkDevKey", {"devKey"=>@devKey})
  end

  def reportTCResult(tcid, tpid, build_id, platform_id,status)
    args = {"devKey"=>@devKey,
            "testcaseid"=>tcid,
            "testplanid"=>tpid,
            "buildid"=>build_id,
            "platformid"=>platform_id,
            "status"=>status,
            "notes"=>"Result from Marquee"}
    @server.call("tl.reportTCResult", args)
  end

  def get_test_plan_id_by_name(project_name,tp_name)
    args = {"devKey"=>@devKey, "testprojectname"=>project_name, "testplanname"=>tp_name}
    result = @server.call("tl.getTestPlanByName", args)
    result[0]["id"]
  end

  def get_test_platform_id_by_name(testplan_id,platform_name)
    args = {"devKey"=>@devKey,
            "testplanid"=>testplan_id}
    results = @server.call("tl.getTestPlanPlatforms", args)
    results.each do |platform|
      return platform['id'] if platform['name'] == platform_name
    end
    return nil
  end

  def get_build_id_by_name(testplan_id,build_name)
    args = {"devKey"=>@devKey,
            "testplanid"=>testplan_id}
    results = @server.call("tl.getBuildsForTestPlan", args)
    results.each do |build|
      return build['id'] if build['name'] == build_name
    end
    return nil
  end
end

class SaveResultToTestlink
  @queue = :testlink_save_result
  def self.perform(test_round_id,tl_dev_key,tl_project_name,tl_plan_name,tl_build_name,tl_platform_name)
    message = ''
    # substitute your Dev Key Here
    client = TestlinkAPIClient.new(tl_dev_key)
    if client.check_dev_key == true
      tp_id = client.get_test_plan_id_by_name(tl_project_name,tl_plan_name)
      unless tp_id.nil?
        platform_id = client.get_test_platform_id_by_name(tp_id,tl_platform_name)
        build_id = client.get_build_id_by_name(tp_id,tl_build_name)
        if platform_id.nil?
          message << "Failed to get Platform in Testlink with #{tl_platform_name}"
          return
        end
        if build_id.nil?
          message << "Failed to get Build in Testlink with #{tl_build_name}"
          return
        end
        test_round = TestRound.find(test_round_id)
        test_round.get_result_details.each do |result|
          message << "Test case <#{result['case_id']}> with testlink id <#{result[test_link_id]}> --> #{result['result']}\n"
          if result['result'] == 'pass'
           message << "#{client.reportTCResult(result['test_link_id'],tp_id,build_id,platform_id,'p')}\n"
          elsif result['result'] == 'failed'
           message << "#{client.reportTCResult(result['test_link_id'],tp_id,build_id,platform_id,'f')}\n"
          end
        end
        test_round.exported_status = 'Y'
        test_round.save
      else
        message << "Failed to get test plan in Testlink with #{tl_plan_name} in project #{tl_project_name}"
      end
    else
      message << "The devKey given is not valid, please check."
    end
  end

  def self.save(test_round_id)
    Resque.enqueue(SaveResultToTestlink, test_round_id)
  end
end
