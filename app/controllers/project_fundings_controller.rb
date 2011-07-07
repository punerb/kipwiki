class ProjectFundingsController < ApplicationController
  # GET /project_fundings
  # GET /project_fundings.xml
  def index
    @project_fundings = ProjectFunding.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_fundings }
    end
  end

  # GET /project_fundings/1
  # GET /project_fundings/1.xml
  def show
    @project_funding = ProjectFunding.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_funding }
    end
  end

  # GET /project_fundings/new
  # GET /project_fundings/new.xml
  def new
    @project_funding = ProjectFunding.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_funding }
    end
  end

  # GET /project_fundings/1/edit
  def edit
    @project_funding = ProjectFunding.find(params[:id])
  end

  # POST /project_fundings
  # POST /project_fundings.xml
  def create
    project_funding = ProjectFunding.new(params[:project_funding])
    @project = Project.find(params[:project_id])
    @project.project_fundings << project_funding
    respond_to do |format|
      if @project.save
        format.html { redirect_to(edit_project_by_action_type_path(@project, "funding"), :notice => 'Project funding was successfully created.') }
        format.xml  { render :xml => @project_funding, :status => :created, :location => @project_funding }
      else
        format.html { redirect_to(edit_project_by_action_type_path(@project, "funding"), :notice => 'Error saving the project') }
        format.xml  { render :xml => @project_funding.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_fundings/1
  # PUT /project_fundings/1.xml
  def update
    @project_funding = ProjectFunding.find(params[:id])

    respond_to do |format|
      if @project_funding.update_attributes(params[:project_funding])
        format.html { redirect_to(@project_funding, :notice => 'Project funding was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_funding.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_fundings/1
  # DELETE /project_fundings/1.xml
  def destroy
    @project = Project.find(params[:project_id])
    @project.project_fundings.find(params[:id]).delete

    respond_to do |format|
      format.html { redirect_to(project_fundings_url) }
      format.xml  { head :ok }
    end
  end
end
