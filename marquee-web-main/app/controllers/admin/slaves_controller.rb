class Admin::SlavesController < InheritedResources::Base

  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource :class => :Slave

  def create

    save_slave(@slave, params)

    if @slave.errors.any?
      render :new and return
    else
      redirect_to admin_slaves_url
    end
  end

  def update

    save_slave(@slave, params)

    if @slave.errors.any?
      p @slave.errors
      render :edit and return
    else
      redirect_to admin_slaves_url
    end
  end

  protected

  def collection
    @slaves = Slave.all
  end

  def resource
    @slave ||= Slave.find(params[:id])
  end

  def build_resource
    @slave ||= Slave.new
  end

  private

  def save_slave(slave, params)

    slave.name = params[:slave][:name]
    slave.ip_address = params[:slave][:ip_address]
    slave.project_name = params[:slave][:project_name]
    slave.status = params[:slave][:status]
    slave.test_type = params[:slave][:test_type]
    slave.priority = params[:slave][:priority]

    slave.save
  end

end
