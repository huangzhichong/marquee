MarqueeWebMain::Application.routes.draw do

  resources :offer_monitoring_records

  resources :offer_reports

  namespace :admin do
    constraints CanAccessResque do
      mount Resque::Server.new, :at => "/resque"
    end

    get '/', :controller => 'projects', :action => 'index'
    resources :browsers
    resources :test_environments
    resources :operation_systems
    resources :automation_drivers
    resources :slaves
    resources :project_categories
    resources :users
    resources :roles
    resources :team_members
    resources :projects do
      resources :test_suites, :ci_mappings, :mail_notify_settings, :test_rounds, :automation_driver_configs
      get "search_automation_script", :controller => 'test_suites', :action => 'search_automation_script'
    end
    get "activate_user/:id", :controller => "users", :action => "activate"
  end

  get 'status/test_round_status/:id', :controller => 'status', :action => 'test_round_status'
  post 'status/update'
  post 'status/new_build'
  post 'import_data/import_automation_script'
  post 'import_data/import_script_without_test_plan'
  post 'import_data/import_test_plan_from_xml'
  get 'import_data/refresh_testlink_data'
  post 'import_data/import_as_and_tc_status'
  get 'import_data/refresh_testlink_data'

  get 'get_activities_by_project', :controller => 'home', :action => 'get_activities_by_project'

  devise_for :users, :controllers => { :passwords => "passwords" }, :skip => :registrations
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
    resources :base_script_results
    resources :issues
    resources :test_rounds do
      get "rerun", :controller => 'test_rounds', :action => 'rerun'
      get "rerun_failed", :controller => 'test_rounds', :action => 'rerun_failed'
      post "save_to_testlink"
    end
    resources :test_suites
    resources :ci_mappings
    resources :mail_notify_settings
  end

  resources :test_rounds do
    get "config_notify_email"
    post "send_notify_email"
    resources :automation_script_results do
      get "show_logs"
    end
  end

  resources :automation_script_results do
    resources :automation_case_results
    post "save_triage_result"
  end
  resources :issues
  resources :base_script_results do
    resources :base_case_results
  end
  resources :screen_shots

  resources :test_plans do
    resources :test_cases
  end

  resources :automation_scripts do
    get 'view_note'
    get "edit_note"
    post "save_note"
    resources :automation_cases
  end

  get "automation_script_results/:id/rerun", :controller => 'automation_script_results', :action => 'rerun'
  get "automation_script_results/:id/stop", :controller => 'automation_script_results', :action => 'stop'
  get "automation_script_results/:id/add_triage_result", :controller => 'automation_script_results', :action => 'add_triage_result'
  get "automation_script_results/:id/view_triage_result", :controller => 'automation_script_results', :action => 'view_triage_result'

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
  post "functional/generate_automation_results_report"

  root :to => 'home#index'
  get "highcharts",:controller => 'highcharts', :action => 'index'
end
