class Interface::TimeCardsController < ApplicationController

  def metrics
    members = TeamMember.find_all_by_project params[:project] 
    member_timecards = {}
    from = params[:from]
    to = params[:to]
    members.each do |member|
      name = member.name
      if from.nil? && to.nil?
        member_timecards[name] = TimeCard.find_all_by_name name
      elsif !from.nil? && to.nil?
        member_timecards[name] = TimeCard.find_by_name_and_from name, params[:from]
      else
        member_timecards[name] = TimeCard.find_by_name_and_from_and_to name, params[:from], params[:to]
      end
    end
    logger.info member_timecards.inspect

    render :json => member_timecards
    #respond_to do |format|
      #format.xml  { render :xml => member_timecards}
    #  format.json { render :json => member_timecards} 
    #end
  end

end
