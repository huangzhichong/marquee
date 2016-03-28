class ServiceTriggerController < ApplicationController
  def start
    #[:project] - service_name from Jenkins
    #[:environment] - test environment to test against
    #[:branch_name] - which branch is using to run test, master by default
    #[:parameter] - addtional parameter passed to -p
    #[:enable_auto_rerun] - autorerun flag
    #[:version] - version of service, showing in test round's description

    #TODO adding view for add/update service_project_mapping
    #by searching service_name in giving project, get the project_mapping_name
    #if project_mapping_name exist, search if there is any service_trigger_record with open status for same test_environment and project_mapping_name
    #if any service_trigger_record been found, close the related test_round
    #TODO a async job to stop test_round
    #kick off a new test_round by project_mapping_name, add a new record in service_trigger_record
  end

end
