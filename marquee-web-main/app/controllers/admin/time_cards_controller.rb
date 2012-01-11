require 'csv'

class Admin::TimeCardsController < ApplicationController
  respond_to :js
  layout 'no_sidebar'
  before_filter :authenticate_user!
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  def overall
    if params[:date]
      @start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i).beginning_of_week
    else
      @start_date = Date.today.beginning_of_week
    end
    
    if @start_date >= Date.today.beginning_of_week - 21
      @start_date = Date.today.beginning_of_week - 21
    end

    logger.info @start_date
    @time_cards = get_monthly_time_cards
  end

  def upload_time_card_report
    time_card_for_audit = nil
    actual = 0

    csv_data = CSV.parse(params[:file].read())
    csv_data.shift # get rid of header row
    csv_data.each do |parsed|
      team_member = TeamMember.find_by_name(parsed[2])
      unless team_member.nil?
        time_card = TimeCard.find_by_name_and_from_and_to(parsed[2], Date.parse(parsed[0]), Date.parse(parsed[1]))
        time_card = TimeCard.create if time_card.nil?
        time_card.name = parsed[2]
        time_card.from = Date.parse(parsed[0])
        time_card.to = Date.parse(parsed[1])
        time_card.time_working = parsed[4]
        time_card.time_submitted = parsed[5]
        time_card.time_approved = parsed[6]
        time_card.time_rejected = parsed[7]
        time_card.week = time_card.from.cweek
        time_card.save
        time_card_for_audit = time_card
        actual += time_card.time_submitted
      end
    end

    this_week = time_card_for_audit.nil? ? (Date.today - 2).cweek : time_card_for_audit.from.cweek

    TeamMember.scoped.each do |team_member|
      time_card = TimeCard.find_by_name_and_week(team_member.name, this_week)
      if time_card.nil?
        TimeCard.create({
          :name => team_member.name,
          :from => time_card_for_audit.nil? ? (Date.today - 2).beginning_of_week : time_card_for_audit.from,
          :to => time_card_for_audit.nil? ? (Date.today - 2).end_of_week : time_card_for_audit.to,
          :time_working => 0,
          :time_submitted => 0,
          :time_approved => 0,
          :time_rejected => 0,
          :week => this_week,
        })
      end
    end

    unless time_card_for_audit.nil?
      audit_log = TimeCardAuditLog.create({
        :year => time_card_for_audit.from.year,
        :week => time_card_for_audit.from.cweek,
        :time_card_needed => TeamMember.count * 40,
        :time_card_actual => actual
      })
    end

    redirect_to admin_time_cards_overall_path
  end

  def send_notification_email
    if params[:date]
      @start_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i).beginning_of_week
    else
      @start_date = Date.today.beginning_of_week
    end
    
    if @start_date >= Date.today.beginning_of_week - 21
      @start_date = Date.today.beginning_of_week - 21
    end


    # design change: no longer use manager to find email address to send to. Put all the address whant to recv summary notification on cc_list
    time_cards = get_monthly_time_cards
    
    time_cards.each do |name, value|
      if value[:week1][:css_class] == "pink" or value[:week2][:css_class] == "pink" or value[:week3][:css_class] == "pink" or value[:week4][:css_class] == "pink"
        time_cards_to_remind = {}
        time_cards_to_remind[name] = value
        TimecardMailer.remind_mail(value[:email], @start_date, time_cards_to_remind)
      end
    end

    cc_list = time_cards.keys.collect do |name|
      team_member = TeamMember.find_by_name(name)
      team_member.cc_list.split(',')
    end
    cc_list.flatten!.uniq!
    logger.info "#{cc_list.inspect}"
    cc_list.each do |address|
      time_cards_to_notify = {}
      # iterate through the timecards visible to current user and find out all time cards which this address is in cc_list and then send summary to this address
      time_cards.each do |name, time_card|
        time_cards_to_notify[name] = time_card if time_card[:cc_list].include?(address)
      end
      TimecardMailer.summary_email(address, @start_date, time_cards_to_notify).deliver unless time_cards_to_notify.empty?
    end
  end

  def non_compliancy_list
    @compliancy_records = TimeCard.where('time_approved = 40 and time_working = 0 and time_submitted = 0 and time_rejected = 0')
    @not_submitting_records = TimeCard.where('time_approved < 40 and (time_working + time_submitted + time_rejected) < (40 - time_approved)')
    @manager_not_approve_records = TimeCard.where('time_submitted >= 40 and time_approved <= 40')
    @submitted_but_lower_than_limit_records = TimeCard.where('time_approved < 40 and time_approved > 0 and time_submitted = 0')
  end

  def reports
    @logs = TimeCardAuditLog.scoped
  end

  protected
  def get_monthly_time_cards
    @time_cards = {}

    owned_projects = current_user.oracle_projects.collect{|p| p.name}
    owned_team_members = (TeamMember.where(:project => owned_projects) + TeamMember.where("cc_list LIKE '%#{current_user.email}%'")).uniq.collect{|tm| tm.name}

    @week1_time_cards = TimeCard.where(:from => @start_date).where(:name => owned_team_members)

    @week1 = ""
    @week2 = ""
    @week3 = ""
    @week4 = ""
    if TimeCardAuditLog.find_by_week_and_year(@start_date.cweek, @start_date.year).nil?
      @week1 = "no-records"
    end
    if TimeCardAuditLog.find_by_week_and_year((@start_date+7).cweek, (@start_date+7).year).nil?
      @week2 = "no-records"
    end
    if TimeCardAuditLog.find_by_week_and_year((@start_date+14).cweek, (@start_date+14).year).nil?
      @week3 = "no-records"
    end
    if TimeCardAuditLog.find_by_week_and_year((@start_date+21).cweek, (@start_date+21).year).nil?
      @week4 = "no-records"
    end
    
    @week1_time_cards.each do |time_card|
      team_member = TeamMember.find_by_name(time_card.name)
      @time_cards[time_card.name] = {:manager => team_member.manager, :week1 => {:amount => time_card.amount, :css_class => time_card.css_class}}
    end

    @week2_time_cards = TimeCard.where(:from => @start_date + 7).where(:name => owned_team_members)
    @week2_time_cards.each do |time_card|
      if @time_cards.has_key? time_card.name
        @time_cards[time_card.name].merge!({:week2 => {:amount => time_card.amount, :css_class => time_card.css_class}})
        logger.info "Get one member for week2 timecard: #{time_card.name} with amount: #{@time_cards[time_card.name]}"
      else
        logger.info "Got one member without week1 timecard: #{time_card.name}"
        team_member = TeamMember.find_by_name(time_card.name)
        @time_cards[time_card.name] = {:manager => team_member.manager, :week2 => {:amount => time_card.amount, :css_class => time_card.css_class}}
      end
    end

    @week3_time_cards = TimeCard.where(:from => @start_date + 14).where(:name => owned_team_members)
    @week3_time_cards.each do |time_card|
      if @time_cards[time_card.name]
        @time_cards[time_card.name].merge!({:week3 => {:amount => time_card.amount, :css_class => time_card.css_class}})
      else
        team_member = TeamMember.find_by_name(time_card.name)
        @time_cards[time_card.name] = {:manager => team_member.manager, :week3 => {:amount => time_card.amount, :css_class => time_card.css_class}}
      end
    end

    @week4_time_cards = TimeCard.where(:from => @start_date + 21).where(:name => owned_team_members)
    @week4_time_cards.each do |time_card|
      if @time_cards[time_card.name]
        @time_cards[time_card.name].merge!({:week4 => {:amount => time_card.amount, :css_class => time_card.css_class}})
      else
        team_member = TeamMember.find_by_name(time_card.name)
        @time_cards[time_card.name] = {:manager => team_member.manager, :week4 => {:amount => time_card.amount, :css_class => time_card.css_class}}
      end
    end

    @time_cards.each do |key, value|
      team_member = TeamMember.find_by_name(key)
      value[:cc_list] = team_member.cc_list.split(',')
      value[:email] = team_member.email
      if !value.has_key? (:week1)
        if team_member.start_date and (team_member.start_date > @start_date)
          value[:week1] = {:amount => 0, :css_class => 'green'}
        elsif team_member.turn_date and (team_member.turn_date < @start_date)
          value[:week1] = {:amount => 0, :css_class => 'green'}
        else
          value[:week1] = {:amount => 0, :css_class => 'pink'}
        end
      end
      if !value.has_key? (:week2)
        logger.info "Get one team member without week2 timecard: #{key}, #{value}"
        if team_member.start_date and (team_member.start_date > @start_date)
          value[:week2] = {:amount => 0, :css_class => 'green'}
        elsif team_member.turn_date and (team_member.turn_date < @start_date)
          value[:week2] = {:amount => 0, :css_class => 'green'}
        else
          value[:week2] = {:amount => 0, :css_class => 'pink'}
        end
      end
      if !value.has_key? (:week3)
        if team_member.start_date and (team_member.start_date > @start_date)
          value[:week3] = {:amount => 0, :css_class => 'green'}
        elsif team_member.turn_date and (team_member.turn_date < @start_date)
          value[:week3] = {:amount => 0, :css_class => 'green'}
        else
          value[:week3] = {:amount => 0, :css_class => 'pink'}
        end
      end
      if !value.has_key? (:week4)
        if team_member.start_date and (team_member.start_date > @start_date)
          value[:week4] = {:amount => 0, :css_class => 'green'}
        elsif team_member.turn_date and (team_member.turn_date < @start_date)
          value[:week4] = {:amount => 0, :css_class => 'green'}
        else
          value[:week4] = {:amount => 0, :css_class => 'pink'}
        end
      end
    end
    @time_cards
  end

 end
