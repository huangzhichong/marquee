class SyncTimeCardFileController < ApplicationController

  def do 
    SyncTimeCardFile.new.get_files
    render :nothing => true
  end
end
