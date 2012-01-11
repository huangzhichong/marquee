require 'csv'

class Admin::TeamMembersController < InheritedResources::Base
  respond_to :js
  layout 'no_sidebar'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def upload_team_member_list
    csv_data = CSV.parse(params[:file].read())
    csv_data.shift # get rid of header row
    csv_data.each do |parsed|
      member = TeamMember.find_by_name(parsed[0])
      member = TeamMember.create if member.nil?

      member.name = parsed[0]
      member.display_name = parsed[1]
      member.email = parsed[2]
      member.cc_list = parsed[3]
      member.manager = parsed[4]
      member.location = parsed[5]
      member.country = parsed[6]
      member.project = parsed[7]
      member.position = parsed[8]
      member.save
    end

    # rebuild oracle_projects
    TeamMember.all.collect{|t| t.project}.uniq.each do |project|
      unless OracleProject.find_by_name(project)
        OracleProject.create({:name => project})
      end
    end

    redirect_to admin_team_members_path
  end

  protected
  def collection
    projects = current_user.oracle_projects.collect{|p| p.name}
    @search = TeamMember.where(:project => projects).search(params[:search])
    @team_members = @search.all
  end

end
