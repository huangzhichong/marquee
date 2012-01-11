class SlavesController < InheritedResources::Base
  layout 'no_sidebar'
  respond_to :js
  
  def collection
    @search = Slave.scoped.search(params[:search])
    @slaves = @search.page(params[:page]).per(15)
  end

  def resource
    @slave ||= Slave.find(params[:id])
    @search = @slave.slave_assignments.search(params[:search])
    @slave_assignments = @search.page(params[:page]).per(15)
  end

end
