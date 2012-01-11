class DreController < ApplicationController
  respond_to :js
  include JiraQueries # definition of Fnd Jira Query strings
  layout 'report'
  before_filter :set_play_list

  def set_play_list
    @play_list = YAML::load_file(File.join(Rails.root, 'public', 'settings', 'dre_slides_show.yml'))
  end

  def overall
    load_dre_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def platform_dre
    load_dre_data
  end

  def overall_small
    load_dre_data
    render :layout => "embedded"
  end

  def history_small
    load_history_data
    @market_name = params["market"]

    logger.info "market name: #{@market_name}"
    if @market_name == "endurance"
      @market_data = @endurance_data
      @caption = "Endurance DRE - 90 days average"
      @color = '8DB4E3'
    elsif @market_name == "camps"
      @market_data = @camps_data
      @caption = "Camps DRE - 90 days average"
      @color = 'C2D69A'
    elsif @market_name == "sports"
      @market_data = @sports_data
      @caption = "Team Sports DRE - 90 days average"
      @color = 'FFC090'
    elsif @market_name == "nonmarket"
      @market_data = @nonmarket_data
      @caption = "Non Market DRE - 90 days average"
      @color = 'B2A1C7'
    else
      @market_data = @overall_data
      @caption = "Overall DRE - 90 days average"
      @color = '00F754'
    end

    render :layout => "embedded"
  end

  def overall_google_chart
    load_dre_data
    @google_chart_src = "http://chart.apis.google.com/chart?chbh=a,5,17&chs=300x200&cht=bhg&chco=0080ff,ff6fcf,666666,ff6666,65ffff,94b951,f6892c,8db4e3&chds=0,10,0,15,0,15,0,15,0,15,0,15,0,15,0,15&chd=t:#{@overall_dre}|#{@framework_dre}|#{@platform_dre}|#{@membership_dre}|#{@swimming_dre}|#{@camps_dre}|#{@sports_dre}|#{@endurance_dre}&chdl=Program-Wide|Framework|Platform|Membership|Swimming|Camps|Team+Sports|Endurance&chma=|0,10&chm=t#{@overall_dre},000000,0,0,31|t#{@framework_dre},000000,1,-2.167,13,-1|t#{@platform_dre},000000,2,0,13|t#{@membership_dre},000000,3,0,13|t#{@swimming_dre},000000,4,0,13|t#{@camps_dre},000000,5,0,13|t#{@sports_dre},000000,6,0,13|t#{@endurance_dre},000000,7,0,13&chtt=90-Day+DRE&chts=7F7F7F,13.5"
    render :layout => "embedded"
  end

  def automation_coverage_google_chart
    @google_chart_src = "http://chart.apis.google.com/chart?chxt=y&chbh=a&chs=300x200&cht=bvg&chco=94b951,f6892c,8db4e3&chd=t:72|69|32&chdl=Camps|Endurance|Team+Sports&chtt=Automation+Coverage+%25&chts=676767,13.5"
    render :layout => "embedded"
  end

  def in_development_open_bugs_by_priority_google_chart
    load_bugs_by_priority_data
    @google_chart_src = "http://chart.apis.google.com/chart?chs=300x200&cht=p&chco=0B1095&chds=0,287&chd=t:#{@open_p0_bugs},#{@open_p1_bugs},#{@open_p2_bugs},#{@open_p3_bugs},#{@open_p4_bugs}&chl=P0|P1|P2|P3|P4&chma=10|0,26&chtt=In+Development+Open+Bugs+by+Priority&chts=676767,13.5"
    render :layout => "embedded"
  end

  def history_overall
    load_history_overall_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def history_markets
    load_history_markets_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def customer_impact_markets
    load_customer_impact_markets_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def customer_impact_other
    load_customer_impact_other_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def project
    @project_name = params[:name]
    load_project_data
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def custom_ext_found_bugs_by_day
    @project_to_show = params[:project_to_show]
    if @project_to_show
      @project_to_show = @project_to_show.split("&")
      @project_to_show.shift
    end
    logger.info @project_to_show
    load_ext_bug_data

    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  def ext_found_bugs_by_day
    @project_to_show = ["endurance","camps","sports", 'swimming', 'membership', 'platform', 'framework']
    load_ext_bug_data
    # if params[:project_to_show]
    #   @project_to_show = params[:project_to_show]
    #   @project_to_show = @project_to_show.split("#")
    #   @project_to_show.shift
    #   render "custom_ext_found_bugs_by_day"
    # end
    if params[:slide]
      render :layout => 'slideshow'
    end
  end

  # def custom_ext_found_bugs_by_day
  #   load_ext_bug_data
  #   @cut_off = params[:cut_off]
  #   if params[:slide]
  #     render :layout => 'slideshow'
  #   end
  # end

  def regenerate
    # check whether it's from local. otherwise don't accept.
    if request.remote_ip != '127.0.0.1'
      render :text => "Not allowed to generate from anywhere other than the server itself."
    else
    import_data_from_jira

    render :nothing => true
    end
  end

  def slide
    render :layout => "slideshow"
  end

private
  def load_history_overall_data
    @overall_data = Rails.cache.fetch('overall_dre_history'){Report::Project.where(name: 'Overall').first.dres}

    @membership_data = Rails.cache.fetch('membership_dre_history'){Report::Project.where(name: 'Membership').first.dres}

    @framework_data = Rails.cache.fetch('framework_dre_history'){Report::Project.where(name: 'Framework').first.dres}

    @platform_data = Rails.cache.fetch('platform_dre_history'){Report::Project.where(name: 'Platform').first.dres}
  end

  def load_history_markets_data
    load_dre_data
    @endurance_data = Rails.cache.fetch('endurance_dre_history'){Report::Project.where(name: 'Endurance').first.dres}

    @camps_data = Rails.cache.fetch('camps_dre_history'){Report::Project.where(name: 'Camps').first.dres}

    @sports_data = Rails.cache.fetch('sports_dre_history'){Report::Project.where(name: 'Sports').first.dres}

    @swimming_data = Rails.cache.fetch('swimming_dre_history'){Report::Project.where(name: 'Swimming').first.dres}
  end

  def load_dre_data
    @overall_dre = Rails.cache.fetch('overall_dre'){Report::Project.where(name: 'Overall').first.dres.last.value}

    @endurance_dre = Rails.cache.fetch('endurance_dre'){Report::Project.where(name: 'Endurance').first.dres.last.value}

    @camps_dre = Rails.cache.fetch('camps_dre'){Report::Project.where(name: 'Camps').first.dres.last.value}

    @sports_dre = Rails.cache.fetch('sports_dre'){Report::Project.where(name: 'Sports').first.dres.last.value}

    @framework_dre = Rails.cache.fetch('framework_dre'){Report::Project.where(name: 'Framework').first.dres.last.value}

    @platform_dre = Rails.cache.fetch('platform_dre'){Report::Project.where(name: 'Platform').first.dres.last.value}

    @membership_dre = Rails.cache.fetch('membership_dre'){Report::Project.where(name: 'Membership').first.dres.last.value}

    @swimming_dre = Rails.cache.fetch('swimming_dre'){Report::Project.where(name: 'Swimming').first.dres.last.value}

    @ams_dre = Rails.cache.fetch('ams_dre'){Report::Project.where(name: 'Ams').first.dres.last.value}

    @els_dre = Rails.cache.fetch('els_dre'){Report::Project.where(name: 'Els').first.dres.last.value}

    @mobile_dre = Rails.cache.fetch('mobile_dre'){Report::Project.where(name: 'Mobile').first.dres.last.value}

    @commerce_dre = Rails.cache.fetch('commerce_dre'){Report::Project.where(name: 'Commerce').first.dres.last.value}

    @email_dre = Rails.cache.fetch('email_dre'){Report::Project.where(name: 'Email').first.dres.last.value}

    @fus_aus_dre = Rails.cache.fetch('fus_aus_dre'){Report::Project.where(name: 'FusAus').first.dres.last.value}
  end

  def load_customer_impact_markets_data
    @endurance_sev_bugs = Rails.cache.fetch('endurance_bugs_by_severity'){Report::Project.where(name: 'Endurance').first.bugs_by_severities}

    @camps_sev_bugs = Rails.cache.fetch('camps_bugs_by_severity'){Report::Project.where(name: 'Camps').first.bugs_by_severities}

    @sports_sev_bugs = Rails.cache.fetch('sports_bugs_by_severity'){Report::Project.where(name: 'Sports').first.bugs_by_severities}

    @swimming_sev_bugs = Rails.cache.fetch('swimming_bugs_by_severity'){Report::Project.where(name: 'Swimming').first.bugs_by_severities}
  end

  def load_customer_impact_other_data
    @membership_sev_bugs = Rails.cache.fetch('membership_bugs_by_severity'){Report::Project.where(name: 'Membership').first.bugs_by_severities}

    @framework_sev_bugs = Rails.cache.fetch('framework_bugs_by_severity'){Report::Project.where(name: 'Framework').first.bugs_by_severities}

    @platform_sev_bugs = Rails.cache.fetch('platform_bugs_by_severity'){Report::Project.where(name: 'Platform').first.bugs_by_severities}
  end

  def load_project_data
    @bugs_by_who_found = Rails.cache.fetch("#{@project_name.downcase}_bugs_by_who_found"){Report::Project.where(name: @project_name.capitalize).first.bugs_by_who_founds};

    @bugs_by_severity = Rails.cache.fetch("#{@project_name.downcase}_bugs_by_severity"){Report::Project.where(name: @project_name.capitalize).first.bugs_by_severities};

    @technical_debt = Rails.cache.fetch("#{@project_name.downcase}_tech_debt"){Report::Project.where(name: @project_name.capitalize).first.technical_debts}
  end

  def load_ext_bug_data
    @ext_found_bugs = Rails.cache.fetch('ext_found_bugs'){Report::Project.where(name: 'Overall').first.external_bugs_found_by_days}

    ext_found_bugs_all_raw = Rails.cache.fetch('ext_bugs_all'){Report::Project.where(name: 'Overall').first.external_bugs_by_day_alls}
    # we only combine the data required by the client
    @ext_found_bugs_all = []
    ext_found_bugs_all_raw.each do |raw_data|
      data = []
      data << raw_data.date
      data << calculate_summary_of_ext_found_bugs(@project_to_show, raw_data)
      @ext_found_bugs_all << data
    end
  end

  def calculate_summary_of_ext_found_bugs(project_to_show, raw_data)
    result = 0
    result += raw_data.endurance.to_i if project_to_show.include? 'endurance'
    result += raw_data.camps.to_i if project_to_show.include? 'camps'
    result += raw_data.sports.to_i if project_to_show.include? 'sports'
    result += raw_data.swimming.to_i if project_to_show.include? 'swimming'
    result += raw_data.membership.to_i if project_to_show.include? 'membership'
    result += raw_data.platform.to_i if project_to_show.include? 'platform'
    result += raw_data.framework.to_i if project_to_show.include? 'framework'
    result
  end

  def load_bugs_by_priority_data
    @open_p0_bugs = Rails.cache.fetch('open_p0_bugs'){JiraIssue.bugs.open.by_priority('P0').count}
    @open_p1_bugs = Rails.cache.fetch('open_p1_bugs'){JiraIssue.bugs.open.by_priority('P1').count}
    @open_p2_bugs = Rails.cache.fetch('open_p2_bugs'){JiraIssue.bugs.open.by_priority('P2').count}
    @open_p3_bugs = Rails.cache.fetch('open_p3_bugs'){JiraIssue.bugs.open.by_priority('P3').count}
    @open_p4_bugs = Rails.cache.fetch('open_p4_bugs'){JiraIssue.bugs.open.by_priority('P4').count}
  end

  def import_jira_query_result_into_db(result)
    if Rails.env == 'development'
      result.each do |r|
        JiraIssue.create(:key => r[0],
                         :status => r[1],
                         :resolution => r[2],
                         :jira_created => r[3],
                         :jira_resolved => r[4],
                         :priority => r[5],
                         :severity => r[6],
                         :issue_type => r[7],
                         :environment_bug_was_found => r[8],
                         :who_found => r[9],
                         :market => r[10],
                         :planning_estimate_level_two => r[11],
                         :known_production_issue => r[12])
      end
    else
      data = []

      result.each do |r|
        key = r[0].nil? ? nil : r[0].gsub("'", "''")
        status = r[1].nil? ? nil : r[1].gsub("'", "''")
        resolution = r[2].nil? ? nil : r[2].gsub("'", "''")
        jira_created = r[3]
        jira_resolved = r[4]
        priority = r[5].nil? ? nil : r[5].gsub("'", "''")
        severity = r[6].nil? ? nil : r[6].gsub("'", "''")
        issue_type = r[7].nil? ? nil : r[7].gsub("'", "''")
        environment_bug_was_found = r[8].nil? ? nil : r[8].gsub("'", "''")
        who_found = r[9].nil? ? nil : r[9].gsub("'", "''")
        market = r[10].nil? ? nil : r[10].gsub("'", "''")
        planning_estimate_level_two = r[11].nil? ? nil : r[11].to_i
        known_production_issue = r[12].nil? ? nil : r[12].gsub("'", "''")


        data << "('#{key}', '#{status}', '#{resolution}', '#{jira_created}', '#{jira_resolved}', '#{priority}', '#{severity}', '#{issue_type}', '#{environment_bug_was_found}', '#{who_found}', '#{market}', '#{planning_estimate_level_two}', '#{known_production_issue}')"
      end

      sql = "INSERT INTO jira_issues (`key`, `status`, `resolution`, `jira_created`, `jira_resolved`, `priority`, `severity`, `issue_type`, `environment_bug_was_found`, `who_found`, `market`, `planning_estimate_level_two`, `known_production_issue`) VALUES #{data.join(", ")}"

      ActiveRecord::Base.connection.execute sql
    end


  end

  def import_data_from_jira
    JiraIssue.delete_all

    result = FndJira.connection.execute(all_projects_bugs_query_string)
    puts "first query: #{result.count} items."
    import_jira_query_result_into_db(result)

    result2 = FndJira.connection.execute(all_closed_requirements_query_string)
    puts "second query: #{result2.count} items."
    import_jira_query_result_into_db(result2)

    result3 = FndJira.connection.execute(framework_bugs_with_specified_components_query_string)
    puts "third query: #{result3.count} items."
    import_jira_query_result_into_db(result3)

    result4 = FndJira.connection.execute(team_sports_bugs_with_specified_components_query_string)
    puts "fourth query: #{result4.count} items."
    import_jira_query_result_into_db(result4)

    puts "Finished. Imported #{JiraIssue.count} jira issues."

    today = Date.today
    today_str = "#{today.month}/#{today.day}/#{today.year.to_s[2, 2]}"

    # update dre
    %w(Overall Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      p = Report::Project.create(name: project) if p.nil?
      dre = p.dres.where(date: Date.today).first.nil? ? p.dres.build() : p.dres.where(date: Date.today).first
      dre.date = Date.today
      dre.value = JiraIssue.send(project.downcase + '_dre')
      dre.save

      Rails.cache.write(project.downcase + '_dre', dre.value)
      Rails.cache.write(project.downcase + '_dre_history', p.dres)
    end

    # drills down dre for platform components
    %w(Ams Els Mobile Commerce Email FusAus).each do |component|
      p = Report::Project.where(name: component).first
      p = Report::Project.create(name: component) if p.nil?
      dre = p.dres.where(date: Date.today).first.nil? ? p.dres.build() : p.dres.where(date: Date.today).first
      dre.date = Date.today
      dre.value = JiraIssue.send(component.downcase + '_dre')
      dre.save

      Rails.cache.write(component.downcase + '_dre', dre.value)
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      bugs = p.bugs_by_severities.where(date: Date.today).first.nil? ? p.bugs_by_severities.build() : p.bugs_by_severities.where(date: Date.today).first
      bugs.date = Date.today
      bugs.severity_1 = (JiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev1').count.to_s
      bugs.severity_2 = (JiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev2').count.to_s
      bugs.severity_3 = (JiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev3').count.to_s
      bugs.severity_nyd = (JiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev-NYD').count.to_s
      bugs.save

      Rails.cache.write(project.downcase + '_bugs_by_severity', p.bugs_by_severities)
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      bugs = p.bugs_by_who_founds.where(date: Date.today).first.nil? ? p.bugs_by_who_founds.build() : p.bugs_by_who_founds.where(date: Date.today).first
      bugs.date = Date.today
      bugs.external = (JiraIssue.send project.downcase).bugs.production.open.external.count.to_s
      bugs.internal = (JiraIssue.send project.downcase).bugs.production.open.internal.count.to_s
      bugs.closed_requirements = (JiraIssue.send project.downcase).requirement.closed.count.to_s
      bugs.save

      Rails.cache.write(project.downcase + '_bugs_by_who_found', p.bugs_by_who_founds)
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      debt = p.technical_debts.where(date: Date.today).first.nil? ? p.technical_debts.build() : p.technical_debts.where(date: Date.today).first
      debt.date = Date.today
      debt.priority_0 = JiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P0').to_s
      debt.priority_1 = JiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P1').to_s
      debt.priority_2 = JiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P2').to_s
      debt.priority_3 = JiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P3').to_s
      debt.priority_4 = JiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P4').to_s
      debt.save

      Rails.cache.write(project.downcase + '_tech_debt', p.technical_debts)
    end

    p = Report::Project.where(name: 'Overall').first
    bugs = p.external_bugs_found_by_days.where(date: Date.today).first.nil? ? p.external_bugs_found_by_days.build() : p.external_bugs_found_by_days.where(date: Date.today).first
    bugs.date = Date.today
    bugs.severity_1 = JiraIssue.bugs.production.found_today.external.by_severity('Sev1').count.to_s
    bugs.severity_2 = JiraIssue.bugs.production.found_today.external.by_severity('Sev2').count.to_s
    bugs.save

    Rails.cache.write('ext_found_bugs', p.external_bugs_found_by_days)

    bugs = p.external_bugs_by_day_alls.where(date: Date.today).first.nil? ? p.external_bugs_by_day_alls.build() : p.external_bugs_by_day_alls.where(date: Date.today).first
    bugs.date = Date.today
    bugs.endurance = JiraIssue.endurance.bugs.production.external.found_today.count.to_s
    bugs.camps = JiraIssue.camps.bugs.production.external.found_today.count.to_s
    bugs.sports = JiraIssue.sports.bugs.production.external.found_today.count.to_s
    bugs.swimming = JiraIssue.swimming.bugs.production.external.found_today.count.to_s
    bugs.membership = JiraIssue.membership.bugs.production.external.found_today.count.to_s
    bugs.platform = JiraIssue.platform.bugs.production.external.found_today.count.to_s
    bugs.framework = JiraIssue.framework.bugs.production.external.found_today.count.to_s
    bugs.save

    Rails.cache.write('ext_bugs_all', p.external_bugs_by_day_alls)
  end

end