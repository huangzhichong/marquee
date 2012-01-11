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

    passowrd = params[:user][:password]
    password = "111111" if params[:user][:password] or params[:user][:password] == ""

    user = User.new(:email => params[:user][:email], :display_name => display_name, :password => passowrd)

    role_id = params[:role_id]
    user.update_role(role_id) if role_id

    oracle_project_ids = params[:user][:oracle_project_ids]
    if oracle_project_ids
      oracle_project_ids.shift
      user.update_oracle_projects(oracle_project_ids) if oracle_project_ids.count > 0
    end

    uads = params[:user][:user_ability_definitions]
    if uads
      uad_array = uads.split("||")
      uad_array.shift
      if uad_array.count > 0
        user.user_ability_definitions.delete_all
        uad_array.each do |uad|
          iterms = uad.split(" ")
          ability = iterms[1]
          resource = iterms[2]
          UserAbilityDefinition.create_for_user(user, ability, resource)
        end
      end
    end

    user.save
    redirect_to admin_users_path
  end

  def update
    user = User.find(params[:id])
    user.display_name = params[:user][:display_name]

    role_id = params[:role_id]
    user.update_role(role_id) if role_id

    oracle_project_ids = params[:user][:oracle_project_ids]
    if oracle_project_ids
      oracle_project_ids.shift
      user.update_oracle_projects(oracle_project_ids) if oracle_project_ids.count > 0
    end

    uads = params[:user][:user_ability_definitions]
    if uads
      uad_array = uads.split("||")
      uad_array.shift
      if uad_array.count > 0
        user.user_ability_definitions.delete_all 
        uad_array.each do |uad|
          iterms = uad.split(" ")
          ability = iterms[1]
          resource = iterms[2]
          UserAbilityDefinition.create_for_user(user, ability, resource)
        end
      end
    end

    user.save
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
end
