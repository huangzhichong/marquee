class Admin::UsersController < InheritedResources::Base
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    names = []
    if params[:user][:display_name].nil? or params[:user][:display_name] == ""
      names = params[:user][:email].split("@").first.split(".")
    else
      names = params[:user][:display_name].strip.split(" ")
    end
    display_name = "#{names.first.capitalize} #{names.last.capitalize}"

    password = params[:user][:password]
    password = "111111" if password.nil? or password.strip.empty?

    user = User.new(:email => params[:user][:email], :display_name => display_name, :password => password)

    save_user!(user, params)

    redirect_to admin_users_path
  end

  def update
    user = User.find(params[:id])
    user.display_name = params[:user][:display_name]

    save_user!(user, params)

    redirect_to admin_user_path(user)
  end

  protected
  def collection
    @search = User.order('id desc').search(params[:search])
    @users = @search.page(params[:page]).per(15)
  end

  def resource
    @user = User.find(params[:id])
  end

  private
  def save_user!(user, params)
    update_oralce_projects(user, params)

    set_projects_roles!(user, params)
    set_ability_definitions!(user, params)

    user.save    
  end

  def update_oralce_projects(user, params)
    oracle_project_ids = params[:user][:oracle_project_ids]
    if oracle_project_ids
      oracle_project_ids.shift
      user.update_oracle_projects(oracle_project_ids) if oracle_project_ids.count > 0
    end    
  end

  def set_projects_roles!(user, params)
    uprs = params[:user][:projects_roles]
    user.projects_roles = Array.new
    if uprs
      upr_array = uprs.split("||")
      upr_array.shift
      upr_array.each do |upr|
        upr_str = upr.split(",")
        role_id = upr_str[0]
        project_id = upr_str[1]
        project_id = nil if project_id == "0"
        project_role = ProjectsRoles.find_by_role_id_and_project_id(role_id, project_id)
        project_role = ProjectsRoles.new(:role_id => role_id, :project_id => project_id) if project_role.nil?
        user.projects_roles << project_role
      end
    end
  end

  def set_ability_definitions!(user, params)
    uads = params[:user][:ability_definitions]
    user.ability_definitions = Array.new
    if uads
      uad_array = uads.split("||")
      uad_array.shift
      uad_array.each do |uad|
        ad_projects_array = uad.split("in")
        ad = ad_projects_array[0]
        project_name = ad_projects_array[1].strip
        ad_array = ad.split(" ")
        ability = ad_array[1]
        resource = ad_array[2]
        ability_definition = AbilityDefinition.find_by_ability_and_resource(ability, resource)
        ability_definition = AbilityDefinition.new(:ability => ability, :resource => resource) if ability_definition.nil?
        if project_name != "All"
          project_name = project_name.strip
          project = Project.find_by_name(project_name.strip)
          project_id = project.id
        end
        ability_definition_user = AbilityDefinitionsUsers.new(:ability_definition => ability_definition, :user_id => user.id, :project_id => project_id)
        user.ability_definitions << ability_definition_user
      end
    end   
  end

end
