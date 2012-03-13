class Widgets::TimeCardsController < ApplicationController
  respond_to :js
  layout 'no_frame'

  def members
    @wid = params[:widget_id]
    logger.info "widget_id:#{@wid}"
    if !@wid
      #render to error page
    end
    selected = MetricsMembersSelection.find_all_by_widget_id(@wid).collect{|ob| ob.team_member_id}
    @selected_members = TeamMember.find_all_by_id selected
    logger.info @selected_members.inspect
  end

  def members_select
    selected = params[:selected_ids]
    wid = params[:widget_id]
    logger.info "selected:#{selected}"
    if selected
      MetricsMembersSelection.transaction do
        MetricsMembersSelection.delete_all(["widget_id = ?", wid])
        selected.split(',').each do |mid|
          selection = MetricsMembersSelection.new
          selection.widget_id = wid
          selection.team_member_id = mid 
          selection.save
        end
      end
    end
   # redirect_to :action => :show, :widget_id => wid
    redirect_to :action => :members, :widget_id => wid
  end

  def show 
    wid = params[:widget_id]
    mms = MetricsMembersSelection.find_all_by_widget_id wid
    logger.info("mms with #{wid} are: #{mms}")
    if(mms.empty?)
      #render to members_list to 
      redirect_to :action => 'members', :widget_id => wid
    end
    selected = MetricsMembersSelection.find_all_by_widget_id(wid).collect{|mms| mms.team_member_id}
    members = TeamMember.where(:id => selected).collect{|tm| tm.name}
    logger.info members
    @start_date = Date.today.end_of_month.end_of_week - 27

    logger.info @start_date
    @time_cards = get_monthly_time_cards members 
  end

  protected
  def get_monthly_time_cards(owned_team_members)
    @time_cards = {}
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
