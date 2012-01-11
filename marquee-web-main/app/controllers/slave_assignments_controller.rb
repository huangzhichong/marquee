class SlaveAssignmentsController < InheritedResources::Base
  respond_to :js
  
  def collection
    @slave = Slave.find(params[:slafe_id])
    @search = @slave.slave_assignments.order('automation_script_result_id desc').search(params[:search])
    @slave_assignments = @search.page(params[:page]).per(15)
  end
  
end
