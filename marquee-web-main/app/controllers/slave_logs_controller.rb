class SlaveLogsController < ApplicationController
  layout 'application'

  def index    
    if params[:ip]
      start_time = params[:start_time] ? Time.zone.parse(params[:start_time].to_s) - 30: Time.now-900
      end_time = params[:end_time] ? Time.zone.parse(params[:end_time].to_s) + 30 : Time.now 
      @searched_logs = SlaveLog.where(:ip => params[:ip],:timestamp.gt => start_time,:timestamp.lt => end_time).asc(:_id)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end

end