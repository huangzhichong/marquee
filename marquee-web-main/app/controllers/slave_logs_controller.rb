class SlaveLogsController < ApplicationController
  layout 'application'

  def index    
    # @search = Log.where( '$and' => [{:ip => params[:ip]},{:timestamp => {'$gt' => Time.zone.parse(params[:timestamp])}}]).sort(:_id.asc)
    @slave_logs = SlaveLog.all
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end

end