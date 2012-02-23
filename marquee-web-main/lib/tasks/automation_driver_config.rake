def create_adc_for_project(project, test_type, automation_driver, source_paths, source_main_path, source_control, sc_username=nil, sc_password = nil)
  AutomationDriverConfig.create(
                                :name => "#{project.name}_#{test_type}",
                                :project_id => project.id,
                                :automation_driver_id => automation_driver.id,
                                :source_control => source_control,
                                :source_paths => source_paths.to_json,
                                :script_main_path => source_main_path,
                                :sc_username => sc_username,
                                :sc_password => sc_password
                                )
end

desc "add initial automation driver configs"
task :add_initial_adc => :environment do
  qtp_driver = AutomationDriver.create(:name => 'qtp', :version => '10.0')
  soapui_driver = AutomationDriver.create(:name => 'soapui', :version => '10.0')
  rspec_driver = AutomationDriver.create(:name => 'rspec', :version => '10.0')
  testng_driver = AutomationDriver.create(:name => 'testng', :version => '10.0')

  sc_username = "campsauto"
  sc_password = "!qaz2wsx1"

  p = Project.find_by_name('Camps')
  unless p.nil?
    bvt_source_paths = [
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/testsuites_marquee/BVTs"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\BVTs\\"

    create_adc_for_project(p, 'BVT', qtp_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)

    reg_source_paths = [
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\regressions", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Camps/trunk/framework/regressions"}
                                 ]
    reg_main_path = "C:\\QA Automation\\Camps\\trunk\\framework\\testsuites_marquee\\regressions\\"

    create_adc_for_project(p, 'Regression', qtp_driver, reg_source_paths, reg_main_path, 'svn', sc_username, sc_password)
  end

  p = Project.find_by_name('Endurance')
  unless p.nil?
    bvt_source_paths = [
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\Dashboard BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/testsuites/Dashboard BVTs"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\Dashboard BVTs\\"

    create_adc_for_project(p, 'BVT', qtp_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)

    reg_source_paths = [
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\regressions", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/testsuites/regressions"}
                                 ]
    reg_main_path = "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\regressions\\"

    create_adc_for_project(p, 'Regression', qtp_driver, reg_source_paths, reg_main_path, 'svn', sc_username, sc_password)
  end

  p = Project.find_by_name('Sports')
  unless p.nil?
    bvt_source_paths = [
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\testsuites\\BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/testsuites/BVTs"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Sports\\trunk\\framework\\testsuites\\BVTs\\"

    create_adc_for_project(p, 'BVT', qtp_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)

    reg_source_paths = [
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Sports\\trunk\\framework\\testsuites\\regressions", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Sports/trunk/framework/testsuites/regressions"}
                                 ]
    reg_main_path = "C:\\QA Automation\\Sports\\trunk\\framework\\testsuites\\regressions\\"

    create_adc_for_project(p, 'Regression', qtp_driver, reg_source_paths, reg_main_path, 'svn', sc_username, sc_password)
  end

  p = Project.find_by_name('Giving')
  unless p.nil?
    bvt_source_paths = [
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\Dashboard BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/testsuites/Dashboard BVTs"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\Dashboard BVTs\\"

    create_adc_for_project(p, 'BVT', qtp_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)

    reg_source_paths = [
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\regressions\\FUI", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Endurance/trunk/framework/testsuites/regressions/FUI"}
                                 ]
    reg_main_path = "C:\\QA Automation\\Endurance\\trunk\\framework\\testsuites\\regressions\\FUI\\"

    create_adc_for_project(p, 'Regression', qtp_driver, reg_source_paths, reg_main_path, 'svn', sc_username, sc_password)
  end

  p = Project.find_by_name('Backoffice')
  unless p.nil?
    bvt_source_paths = [
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\testsuites\\Dashboard BVTs", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/testsuites/Dashboard BVTs"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Backoffice\\trunk\\framework\\testsuites\\Dashboard BVTs\\"

    create_adc_for_project(p, 'BVT', qtp_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)

    reg_source_paths = [
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/package"},
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\datapools", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/datapools"},
                                  {"local" => "C:\\QA Automation\\Backoffice\\trunk\\framework\\testsuites\\regressions", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Backoffice/trunk/framework/testsuites/regressions"}
                                 ]
    reg_main_path = "C:\\QA Automation\\Backoffice\\trunk\\framework\\testsuites\\regressions\\"

    create_adc_for_project(p, 'Regression', qtp_driver, reg_source_paths, reg_main_path, 'svn', sc_username, sc_password)
  end

  p = Project.find_by_name('Membership')
  unless p.nil?
    bvt_source_paths = [
                        {"local" => "C:\\QA Automation\\Membership\\trunk\\framework\\package", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Membership/trunk/framework/package"},
                        {"local" => "C:\\QA Automation\\Membership\\trunk\\framework\\common", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Membership/trunk/framework/common"},
                        {"local" => "C:\\QA Automation\\Membership\\trunk\\framework\\components", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Membership/trunk/framework/components"},
                        {"local" => "C:\\QA Automation\\Membership\\trunk\\framework\\objects", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Membership/trunk/framework/objects"},
                        {"local" => "C:\\QA Automation\\Membership\\trunk\\framework\\testsuites", "remote" => "https://fndsvn.dev.activenetwork.com/foundation/QA Automation/Membership/trunk/framework/testsuites"}
                                 ]
    bvt_main_path = "C:\\QA Automation\\Membership\\trunk\framework\\"

    create_adc_for_project(p, '', rspec_driver, bvt_source_paths, bvt_main_path, 'svn', sc_username, sc_password)
  end

end
