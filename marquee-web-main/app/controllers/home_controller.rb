require 'csv'

class HomeController < ApplicationController
  def index
    #@overall_dre = Rails.cache.fetch('overall_dre'){Report::Project.where(name: 'Overall').first.dres.last.value}

    #@endurance_dre = Rails.cache.fetch('endurance_dre'){Report::Project.where(name: 'Endurance').first.dres.last.value}

    #@camps_dre = Rails.cache.fetch('camps_dre'){Report::Project.where(name: 'Camps').first.dres.last.value}

    #@sports_dre = Rails.cache.fetch('sports_dre'){Report::Project.where(name: 'Sports').first.dres.last.value}

    #@framework_dre = Rails.cache.fetch('framework_dre'){Report::Project.where(name: 'Framework').first.dres.last.value}

    #@platform_dre = Rails.cache.fetch('platform_dre'){Report::Project.where(name: 'Platform').first.dres.last.value}

    #@membership_dre = Rails.cache.fetch('membership_dre'){Report::Project.where(name: 'Membership').first.dres.last.value}

    #@swimming_dre = Rails.cache.fetch('swimming_dre'){Report::Project.where(name: 'Swimming').first.dres.last.value}

    @project_count = Project.count
    @automation_script_count = AutomationScript.count
    @automation_case_count = AutomationCase.count
    @test_round_count = TestRound.count
    # @activities = Activity.scoped.order('created_at desc').page(0).per(5)
    
    @activities = Audit.where(:auditable_type => "TestRound", :action => "create").order('created_at desc').limit(5)
    @activities.each do |activity|
      if activity.user.nil?
        activity.user = User.automator
        activity.save
      end
    end
    
    # @camps_overall_coverage = Rails.cache.fetch("camps_overall_coverage"){ Project.caculate_coverage_by_project_and_priority("Camps","Overall") }
    # @camps_overall_goal = Rails.cache.fetch("camps_overall_goal"){ 95 }
    # @endurance_overall_coverage = Rails.cache.fetch("endurance_overall_coverage"){ Project.caculate_coverage_by_project_and_priority("Endurance","Overall") }
    # @endurance_overall_goal = Rails.cache.fetch("endurance_overall_goal"){ 90 }
    # @sports_overall_coverage = Rails.cache.fetch("sports_overall_coverage"){ Project.caculate_coverage_by_project_and_priority("Sports","Overall") }
    # @sports_overall_goal = Rails.cache.fetch("sports_overall_goal"){ 90 }
    # @membership_overall_coverage = Rails.cache.fetch("membership_overall_coverage"){ Project.caculate_coverage_by_project_and_priority("Membership","Overall") }

    camps_regression_coverage = []
    %w(Overall).each do |priority|
      # @cui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"CUI")
      # @aui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"AUI")
      camps_regression_coverage << Project.caculate_coverage_by_project_and_priority_and_type("Camps", priority,"regression")
      # @coverage << Project.caculate_coverage_by_project_and_priority(project_name,priority)
    end
    @camps_overall_coverage = camps_regression_coverage[0]
  end

  def get_activities_by_project
    name = params[:name]
    project = Project.find_by_name(name)
    tr_ids = project.test_rounds.collect{|tr| tr.id}

    if name.blank?
      @activities = Audit.where(:auditable_type => "TestRound", :action => "create").order('created_at desc').limit(5)
    else
      @activities = Audit.where(:auditable_type => "TestRound", :action => "create",  :auditable_id => tr_ids).order('created_at desc').limit(5)
    end

    @activities.each do |activity|
      if activity.user.nil?
        activity.user = User.automator
        activity.save
      end
    end
    render :partial => "home/activities"
  end
end
