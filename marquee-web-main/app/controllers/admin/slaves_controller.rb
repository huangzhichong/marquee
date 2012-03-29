class Admin::SlavesController < InheritedResources::Base

  layout 'admin'
  respond_to :js

  before_filter :authenticate_user!
  load_and_authorize_resource

  def collection
    @search = Slave.scoped.search(params[:search])
    @slaves = @search.page(params[:page]).order('name').per(15)
  end

  def create

    create!{admin_slaves_url}
  end

  def update

    update!{admin_slaves_url}
  end

end
