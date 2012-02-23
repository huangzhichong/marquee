desc "add initial automation driver configs"
task :add_initial_adc => :environment do
  p = Project.find_by_name("Camps")
  driver1 = AutomationDriver.create(:name => 'qtp', :version => '10.0')
  driver2 = AutomationDriver.create(:name => 'soapui', :version => '10.0')
  driver3 = AutomationDriver.create(:name => 'selenium', :version => '10.0')

  source_paths_bvt = []
  source_paths_bvt << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/package"}
  source_paths_bvt << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"}
  source_paths_bvt << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"}

  source_paths_regression = []
  source_paths_regression << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/package"}
  source_paths_regression << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"}
  source_paths_regression << {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\regressions", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"}


  source_control = "svn"

  script_main_path_bvt = "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\BVTs\\"
  script_main_path_regression = "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\regressions\\"

  svn_username = "campsauto"
  svn_password = Base64.encode64("!qaz2wsx1")

  adc_bvt = AutomationDriverConfig.create(:name => "Camps_BVT", :project_id => p.id, :automation_driver_id => driver1.id, :source_control => source_control, :source_paths => source_paths_bvt.to_json, :script_main_path => script_main_path_bvt, :sc_username => svn_username, :sc_password => svn_password)

  adc_regression = AutomationDriverConfig.create(:name => "Camps_Regression", :project_id => p.id, :automation_driver_id => driver1.id, :source_control => source_control, :source_paths => source_paths_regression.to_json, :script_main_path => script_main_path_regression, :sc_username => svn_username, :sc_password => svn_password)
end
