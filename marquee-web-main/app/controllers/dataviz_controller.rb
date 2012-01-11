class DatavizController < ApplicationController
  layout "d3"
  include JiraQueries

  def test001

  end

  def group_effort_tracking
    @groups = ["CN_APS_DEV", "CN_Framework_DEV"]
    @start_date = (Date.today).beginning_of_week
    @end_date = (Date.today).end_of_week - 1.days
    Jira::WorkLog2.delete_all

    @groups.each do |group|
      q = get_work_logs_by_group_and_date_range_without_version(group, @start_date, @end_date)
      FndJira.connection.execute(q).each do |result|
        wl = Jira::WorkLog2.new
        wl.jira_id = result[0].to_i
        wl.author = result[5]
        wl.start_date = result[3]
        wl.time_worked = result[4].to_i
        wl.save
      end
    end

    @authors = Jira::WorkLog2.all.collect{|wl| wl.author}.uniq

    @data = []
    
    @authors.each do |author|
      data = []

      @start_date.upto(@end_date - 1.days) do |day|
        sum = 0
        Jira::WorkLog2.where(author: author).each do |wl|
          if (wl.start_date.to_date == day)
            sum += wl.time_worked
          end
        end
        data << (sum / 3600.0).round
      end

      @data << [author, data]
    end
    
  end

  def index
    @configs = Report::InDevelopmentTrackingConfig.all
  end

  def new_in_development_tracking_config
    @config = Report::InDevelopmentTrackingConfig.new
    @config.start_date = Date.today - 10
    @config.end_date = Date.today + 10
  end

  def create_in_development_tracking_config
    @config = Report::InDevelopmentTrackingConfig.create
    @config.name = params[:name]
    @config.jira_project = params[:jira_project]
    @config.jira_key = params[:jira_key]
    @config.jira_version = params[:jira_version]
    @config.jira_group = params[:jira_group]
    @config.start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
    @config.end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      
    categories = [params[:extra_categories][:name].reject{|n| n.blank?}, params[:extra_categories][:jira_key].reject{|n| n.blank?}].transpose
    categories.each do |cat|
      category = @config.extra_categories.build
      category.name = cat[0]
      category.jira_key = cat[1]
    end

    @config.save
    
    # schedule data pull task for it
    PullDataTask.new(@config.id).delay(:period => params[:period].to_i, :at => params[:at]).for_in_development_tracking_report()
  end

  def pull_data_for_report
    @config = Report::InDevelopmentTrackingConfig.find(params[:config_id])

    render :nothing => true
  end

  def in_development_tracking_report
    config_id = params[:config_id]
    @config = Report::InDevelopmentTrackingConfig.find(config_id)
    if @config.nil?
      render "Couldn't find in development tracking config for id: #{config_id}"
    else
      @tracking = @config.trackings.last
      if @tracking.nil?
        render "No data pulling completed yet for in development tracking config: #{config_id}"
      else
        @total_effort = (@tracking.total_time_worked / 3600.0).round()
        @in_release_effort = (@tracking.in_release_time_worked / 3600.0).round()
        @out_release_effort = (@tracking.out_of_release_time_worked / 3600.0).round()
        @other_proj_effort = (@tracking.out_of_project_time_worked / 3600.0).round()
        @detail_effort_distribution_data = [
          @tracking.time_spent_on_new_features/3600.0,
          @tracking.time_spent_on_bug_sub_tasks/3600.0,
          @tracking.time_spent_on_bugs/3600.0,
          @tracking.time_spent_on_production_support/3600.0,
        ]

        @detail_effort_distribution_labels = [
          "#{(@tracking.time_spent_on_new_features / 3600.0).round()} on New Features",
          "#{(@tracking.time_spent_on_bug_sub_tasks / 3600.0).round()} on Bug Sub-Tasks",
          "#{(@tracking.time_spent_on_bugs / 3600.0).round()} on Bugs",
          "#{(@tracking.time_spent_on_production_support / 3600.0).round()} on Production Support",
        ]

        @config.extra_categories.each do |category|
          @detail_effort_distribution_data << (@tracking.time_spent_on_extra_category(category) / 3600.0).round()
          @detail_effort_distribution_labels << "#{(@tracking.time_spent_on_extra_category(category) / 3600.0).round()} on #{category.name}"
        end

        @open_bugs_count_by_priority = [
          @tracking.p0_open_bugs_count,
          @tracking.p1_open_bugs_count,
          @tracking.p2_open_bugs_count,
          @tracking.p3_open_bugs_count,
          @tracking.p4_open_bugs_count,
        ]

        a = []
        @tracking.daily_open_bugs_count_string.split(';').inject(a){|a, s| a << s.split('|')[1]}
        @open_bugs_count_by_day = a

        b = []
        @tracking.daily_open_bugs_count_string.split(';').inject(b){|a, s| a << s.split('|')[0]}
        @open_bugs_count_by_day_labels = b
      end
    end
  end

  def show_report
    @config = Report::InDevelopmentTrackingConfig.find(params[:config_id])
  end
end