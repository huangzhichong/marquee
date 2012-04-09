require File.expand_path('../../helpers/jira_data_sync', __FILE__)
require File.expand_path('../../helpers/sync_time_card_file', __FILE__)

class DataSyncController < ApplicationController

  def fnd_jira
    JiraDataSync.createJob
    render :nothing => true
  end

  def time_card
    SyncTimeCardFile.createJob
    render :nothing => true
  end

end

