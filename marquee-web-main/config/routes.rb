MarqueeWebMain::Application.routes.draw do

  namespace :admin do
    constraints CanAccessResque do
      mount Resque::Server.new, :at => "/resque"
    end

    resources :project_categories, :users
    resources :team_members
    resources :projects do
      resources :test_suites, :ci_mappings, :mail_notify_settings, :test_rounds
      get "search_automation_script", :controller => 'test_suites', :action => 'search_automation_script'
    end
    get 'time_cards/overall', :controller => 'time_cards', :action => 'overall'
    get 'time_cards/non_compliancy_list', :controller => 'time_cards', :action => 'non_compliancy_list'
    get 'time_cards/reports', :controller => 'time_cards', :action => 'reports'
    post 'time_cards/upload_time_card_report', :controller => 'time_cards', :action => 'upload_time_card_report'
    post 'team_members/upload_team_member_list', :controller => 'team_members', :action => 'upload_team_member_list'
    post 'time_cards/send_notification_email', :controller => 'time_cards', :action => 'send_notification_email'
    get "dre_slide_show/configure"
    post "dre_slide_show/update"
    get "jira_data/effort_analysis"
    get "jira_data/issue_status_chronicle/:key", :controller => 'jira_data', :action => 'issue_status_chronicle'
    get "projects_display_order", :controller => "projects", :action => "display_order"
    post "projects_display_order_update", :controller => "projects", :action => "display_order_update"
  end

  post 'status/update'
  post 'status/new_build'
  post 'import_data/import_automation_script'
  post 'import_data/import_script_without_test_plan'
  post 'import_data/import_test_plan_from_xml'
  get 'import_data/refresh_testlink_data'
  post 'import_data/import_as_and_tc_status'
  get 'import_data/refresh_testlink_data'  

  devise_for :users, :controllers => { :passwords => "passwords" }
  resources :passwords
  # get "users/:id/password/edit", :controller => "passwords", :action => "edit"

  resources :slaves do
    resources :slave_assignments
  end

  resources :project_categories

  resources :projects do
    get 'coverage', :on => :member
    resources :test_plans
    resources :automation_scripts
    resources :test_rounds
    resources :test_suites
    resources :ci_mappings
    resources :mail_notify_settings
  end

  resources :test_rounds do
    resources :automation_script_results
  end

  resources :automation_script_results do
    resources :automation_case_results
  end

  resources :screen_shots

  resources :test_plans do
    resources :test_cases
  end

  resources :automation_scripts do
    resources :automation_cases
  end

  get "dre/regenerate"

  get "dre/history_small"
  get "dre/platform_dre"
  get "dre/overall_small"
  get "dre/overall_google_chart"
  get "dre/automation_coverage_google_chart"
  get "dre/in_development_open_bugs_by_priority_google_chart"
  get "dre/overall"
  get "dre/history_overall"
  get "dre/history_markets"
  get "dre/customer_impact_markets"
  get "dre/customer_impact_other"
  get "dre/project/:name", :controller => 'dre', :action => 'project'
  get "dre/ext_found_bugs_by_day"
  get "dre/custom_ext_found_bugs_by_day/:project_to_show", :controller => 'dre', :action => 'custom_ext_found_bugs_by_day'

  get "update_automation_script_result_triagge_result", :controller => 'automation_script_results', :action => 'update_triage_result'
  get "automation_script_results/:id/rerun", :controller => 'automation_script_results', :action => 'rerun'
  get "automation_script_results/:id/stop", :controller => 'automation_script_results', :action => 'stop'

  get "dre/slide"
  get "dre/overall_slide"
  get "dre/history_slide"
  get "dre/endurance_slide"
  get "dre/camps_slide"
  get "dre/sports_slide"
  get "dre/nonmarket_slide"
  get "dre/customer_impact_slide"
  get "dre/ext_found_bugs_by_day_slide"

  get "dre/platform_dre"
  get "functional/bug_report"
  get "functional/rmf_original_estimate"
  get "functional/automation_status_report"
  get "functional/rejected_bug_report"
  get "functional/update_needed_script_report"
  post "functional/generate_automation_status_report"
  post "functional/generate_rejected_bug_report"
  post "functional/rmf_original_estimate_query"
  post "functional/generate_update_needed_script_report"
  post "functional/generate_bug_report"
  get "functional/endurance_qa_effort_report"


  get "experiment/effort_analysis_report"
  get "experiment/ear"
  get "experiment/effort_tracking"
  post "experiment/effort_tracking_report"

  get "dataviz/test001"
  get "dataviz/index"
  get "dataviz/new_in_development_tracking_config"
  post "dataviz/create_in_development_tracking_config"
  get "dataviz/show_report/:config_id", :controller => 'dataviz', :action => 'show_report'
  get "dataviz/in_development_tracking_report/:config_id", :controller => 'dataviz', :action => 'in_development_tracking_report'
  get "dataviz/pull_data_for_report/:config_id", :controller => 'dataviz', :action => 'pull_data_for_report'
  get "dataviz/group_effort_tracking"

  root :to => 'home#index'

end
