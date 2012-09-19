class SlaveLogsController < ApplicationController
  layout 'no_sidebar'

  def index    
    # @search = Log.where( '$and' => [{:ip => params[:ip]},{:timestamp => {'$gt' => Time.zone.parse(params[:timestamp])}}]).sort(:_id.asc)
    @slave_logs = SlaveLog.where(:ip => params[:ip]).asc(:_id)
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end

end