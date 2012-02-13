namespace :dash do

  desc "Init some user and project data"
  task :init_data => :environment do
    AbilityDefinition.delete_all
    User.delete_all
    Role.delete_all
    RolesUsers.delete_all
    AutomationCaseResult.delete_all
    AutomationCase.delete_all
    AutomationScriptResult.delete_all
    AutomationScript.delete_all
    TestCase.delete_all
    TestPlan.delete_all
    TestRound.delete_all
    TestSuite.delete_all
    SuiteSelection.delete_all
    TargetService.delete_all
    Project.delete_all
    ProjectCategory.delete_all
    TestType.delete_all
    TestEnvironment.delete_all
    AutomationDriver.delete_all
    Browser.delete_all
    Capability.delete_all
    CiMapping.delete_all
    JiraIssue.delete_all
    Machine.delete_all
    MailNotifySetting.delete_all
    ProjectCategory.delete_all
    RunTask.delete_all
    Slave.delete_all

    aw = ProjectCategory.new(:name => 'ActiveWorks')
    aw.save
    other = ProjectCategory.new(:name => 'Others')
    other.save

    TestType.create(:name => 'BVT').save
    TestType.create(:name => 'Regression').save

    TestEnvironment.create(:name => 'INT Latest', :value => 'INT').save
    TestEnvironment.create(:name => 'INT Released', :value => 'INTR').save
    TestEnvironment.create(:name => 'QA Latest', :value => 'QA').save
    TestEnvironment.create(:name => 'QA Released', :value => 'QAR').save
    TestEnvironment.create(:name => 'QA Staging', :value => 'QAS').save
    TestEnvironment.create(:name => 'Platform INT', :value => 'PINT').save
    TestEnvironment.create(:name => 'Platform QA', :value => 'PQA').save

    admin_role = Role.create(:name => "admin")
    qa_manager_role = Role.create(:name => "qa_manager")
    qa_developer_role = Role.create(:name => "qa_developer")
    qa_role = Role.create(:name => "qa")

    admins = []
    qa_managers = []
    qa_developers = []
    qas = []

    admins << automator = { "email" => 'automator@marquee.com', "name" => 'Marquee Automator' }
    admins << tyrael = { "email" => 'tyrael.tong@activenetwork.com', "name" => 'Tyrael Tong' }
    admins << chris = { "email" => 'chris.zhang@activenetwork.com', "name" => 'Chris Zhang' }
    admins << eric = { "email" => 'eric.yang@activenetwork.com', "name" => 'Eric Yang' }

    qa_managers << smart = { "email" => 'smart.huang@activenetwork.com', "name" => 'Smart Huang' }
    qa_managers << jabco = { "email" => 'jabco.shen@activenetwork.com', "name" => 'Jabco Shen' }
    qa_managers << fiona = { "email" => 'fiona.zhou@activenetwork.com', "name" => 'Fiona Zhou' }

    qa_developers << tina = { "email" => 'tina.xu@activenetwork.com', "name" => 'Tina Xu' }
    qa_developers << sky = { "email" => 'sky.li@activenetwork.com', "name" => 'Sky Li' }
    qa_developers << justin = { "email" => 'justin.luo@activenetwork.com', "name" => 'Justin Luo' }
    qa_developers << evonne = { "email" => 'evonne.fu@activenetwork.com', "name" => 'Evonne Fu' }
    qa_developers << toby = { "email" => 'toby.tang@activenetwork.com', "name" => 'Toby tang' }
    qa_developers << randy = { "email" => 'randy.zhang@activenetwork.com', "name" => 'Randy Zhang' }
    qa_developers << james = { "email" => 'james.lv@activenetwork.com', "name" => 'James Lv' }

    qas << sophie = { "email" => 'sophie.du@activenetwork.com', "name" => 'Sophie Du' }

    role_hashes = Hash.new
    role_hashes["admin"] = admins
    role_hashes["qa_manager"] = qa_managers
    role_hashes["qa_developer"] = qa_developers
    role_hashes["qa"] = qas

    role_hashes.each do |k,v|
      role = Role.find_by_name(k)
      v.each do |user|
        u = User.new(
          :email => user["email"],
          :display_name => user["name"],
          :password => "111111"
        )
        u.roles << role
        u.save
      end
    end

    # todo: define ability for each role
    %w(CiMapping MailNotifySetting TestRound TestSuite TestPlan AutomationScript AutomationScriptResult AutomationCase AutomationCaseResult).each do |resource|
      ad = AbilityDefinition.create
      ad.role = qa_manager_role
      ad.ability = :manage
      ad.resource = resource
      ad.save
    end

    ability_definition = AbilityDefinition.new do |ad|
      ad.role = qa_role
      ad.ability = :create
      ad.resource = 'TestRound'
    end 
    ability_definition.save

    ability_definition = AbilityDefinition.new do |ad|
      ad.role = qa_developer_role
      ad.ability = :update
      ad.resource = 'TestSuite'
    end
    ability_definition.save

    ability_definition = AbilityDefinition.new do |ad|
      ad.role = qa_developer_role
      ad.ability = :update
      ad.resource = 'AutomationScriptResult'
    end
    ability_definition.save

    smart = User.find_by_email("smart.huang@activenetwork.com")
    jabco = User.find_by_email("jabco.shen@activenetwork.com")
    fiona = User.find_by_email("fiona.zhou@activenetwork.com")

    camps = Project.create(
      :name => 'Camps',
      :leader => smart,
      :project_category => aw,
      :state => 'ongoing',
      :source_control_path => 'http://fndsvn.dev.activenetwork.com/camps',
      :icon_image_file_name => 'camps.png',
      :icon_image_content_type => 'image/png',
      :icon_image_file_size => 7763
    ).save

    endurance = Project.create(
      :name => 'Endurance',
      :leader => jabco,
      :project_category => aw,
      :state => 'ongoing',
      :source_control_path => 'http://fndsvn.dev.activenetwork.com/endurance',
      :icon_image_file_name => 'endurance.png',
      :icon_image_content_type => 'image/png',
      :icon_image_file_size => 18857
    ).save

    sports = Project.create(
      :name => 'Sports',
      :leader => fiona,
      :project_category => aw,
      :state => 'ongoing',
      :source_control_path => 'http://fndsvn.dev.activenetwork.com/sports',
      :icon_image_file_name => 'sports.png',
      :icon_image_content_type => 'image/png',
      :icon_image_file_size => 16291
    ).save
  end
  
  desc "Delete duplicated data from dre report."
  task :delete_duplicated_data => :environment do
    Report::Project.all.each do |p|
      p.dres.each do |d|
        d.destroy unless p.dres.where(date: d.date).count == 1
      end
      
      p.bugs_by_severities.each do |bbs|
        bbs.destroy unless p.bugs_by_severities.where(date: bbs.date).count == 1
      end
      
      p.bugs_by_who_founds.each do |bbw|
        bbw.destroy unless p.bugs_by_who_founds.where(date: bbw.date).count == 1
      end
      
      p.technical_debts.each do |td|
        td.destroy unless p.technical_debts.where(date: td.date).count == 1
      end
      
      p.external_bugs_by_day_alls.each do |ebbda|
        ebbda.destroy unless p.external_bugs_by_day_alls.where(date: ebbda.date).count == 1
      end
      
      p.external_bugs_found_by_days.each do |ebbd|
        ebbd.destroy unless p.external_bugs_found_by_days.where(date: ebbd.date).count == 1
      end
    end
  end
  
  task :reset_specified_data , [:date] => :environment do |t, args|
    specified_date = args[:date]
    markets = ["Endurance","Camps","Sports","Swimming","Membership","Platform","Framework"]
    date = Date.strptime(specified_date,"%Y-%m-%d")
    markets.each do |m|
      pre = nil
      pre = Report::Project.where(name: m).first.bugs_by_who_founds.where(date: (date = date-1).strftime("%y-%m-%d")).first until pre
      if pre
        current = Report::Project.where(name: m).first.bugs_by_who_founds.where(date: specified_date).first
        current.closed_requirements = pre.closed_requirements
        current.external = pre.external
        current.internal = pre.internal
        current.save
      end
    end
    
  end
  
  task :delete_specified_data => :environment do
    specified_date = "2011-11-06"
    dres = []
    bugs_by_severities = []
    bugs_by_who_founds = []
    technical_debts = []
    external_bugs_by_day_alls = []
    external_bugs_found_by_days = []
    Report::Project.all.each do |p|
      p.dres.each do |d|
        dres << d if d.date.to_s == specified_date
      end
      
      p.bugs_by_severities.each do |bbs|
        bugs_by_severities << bbs if bbs.date.to_s == specified_date
      end
      
      p.bugs_by_who_founds.each do |bbw|
        bugs_by_who_founds << bbw if bbw.date.to_s == specified_date
      end
      
      p.technical_debts.each do |td|
        technical_debts << td if td.date.to_s == specified_date
      end
      
      p.external_bugs_by_day_alls.each do |ebbda|
        external_bugs_by_day_alls << ebbda if ebbda.date.to_s == specified_date
      end
      
      p.external_bugs_found_by_days.each do |ebbd|
        external_bugs_found_by_days << ebbd if ebbd.date.to_s == specified_date
      end
    end
    
    dres.each do |d|
      d.destroy
    end
    
    bugs_by_severities.each do |d|
      d.destroy
    end
    
    bugs_by_who_founds.each do |d|
      d.destroy
    end
    
    technical_debts.each do |d|
      d.destroy
    end
    
    external_bugs_by_day_alls.each do |d|
      d.destroy
    end
    
    external_bugs_found_by_days.each do |d|
      d.destroy
    end
  end

  desc "add initial mail notify groups"
  task :add_initial_mail_notify_groups => :environment do
    MailNotifyGroup.create(:name => 'test_round_finish')
    MailNotifyGroup.create(:name => 'test_round_triaged')
  end

  desc "adding NA QA users"
  task :add_NA_users => :environment do
    qa_managers = []
    qa_developers = []

    qa_managers << doreen = { "email" => 'Doreen.Xue@activenetwork.com'}
    qa_managers << justin = { "email" => 'Justin.Lakin@activenetwork.com'}
    qa_managers << karen = { "email" => 'Karen.Bishop@activenetwork.com'}
    qa_managers << adan = { "email" => 'adam.english@activenetwork.com'}
    qa_managers << huiping = { "email" => 'Huiping.Zheng@activenetwork.com'}
      
    qa_developers << rob = { "email" => 'Rob.Wallace@activenetwork.com'}
    qa_developers << michael = { "email" => 'Michael.Begley@activenetwork.com'}
    qa_developers << ophelia = { "email" => 'Ophelia.Chan@activenetwork.com'}

    role_hashes = Hash.new
    role_hashes["qa_manager"] = qa_managers
    role_hashes["qa_developer"] = qa_developers

    role_hashes.each do |k,v|
      role = Role.find_by_name(k)
      v.each do |user|
        name = user["email"].split("@").first
        display_name = "#{name.split(".").first.capitalize} #{name.split(".").last.capitalize}"
        u = User.new(
          :email => user["email"],       
          :display_name => display_name,
          :password => "111111"
        )
        u.roles << role
        u.save
      end
    end
  end


end
