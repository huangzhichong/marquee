class SyncTimeCardFileController < ApplicationController

  def do 
    if request.remote_ip != '127.0.0.1'
      render :text => "Not allowed to access from anywhere other than the server itself."
      return
    end
    SyncTimeCardFile.new.get_files
    render :nothing => true
  end
end
