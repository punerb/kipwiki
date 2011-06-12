class ProjectObjectivesController < ApplicationController

  before_filter :set_objectives

  # GET /project_objectives
  # GET /project_objectives.xml
  def index
    @project_objectives = ProjectObjective.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_objectives }
    end
  end

  # GET /project_objectives/1
  # GET /project_objectives/1.xml
  def show
    @project_objective = ProjectObjective.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_objective }
    end
  end

  # GET /project_objectives/new
  # GET /project_objectives/new.xml
  def new
    @project_objective = ProjectObjective.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_objective }
    end
  end

  # GET /project_objectives/1/edit
  def edit
    @project_objective = ProjectObjective.find(params[:id])
  end

  # POST /project_objectives
  # POST /project_objectives.xml
  def create
    @project_objective = @project.project_objectives.new(params[:project_objective])

    respond_to do |format|
      if @project_objective.save
        format.html { redirect_to(edit_project_by_action_type_path(@project, "objective"), :notice => 'Project objective was successfully created.') }
        format.xml  { render :xml => @project_objective, :status => :created, :location => @project_objective }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_objective.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_objectives/1
  # PUT /project_objectives/1.xml
  def update
    @project_objective = ProjectObjective.find(params[:id])
    @project_objective.sub_project_objectives = @project_objective.sub_project_objectives || []
    @project_objective.sub_project_objectives.push(params[:project_objective][:sub_project_objectives])

    respond_to do |format|
      if @project_objective.save#update_attributes(params[:project_objective])
        format.html { redirect_to(edit_project_path(@project), :notice => 'Project objective was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => edit_project_path(@project), :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_objectives/1
  # DELETE /project_objectives/1.xml
  def destroy
    @project_objective = ProjectObjective.find(params[:id])
    @project_objective.destroy

    respond_to do |format|
      format.html { redirect_to(project_objectives_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_objectives
    @project = Project.find(params[:project_id])
  end

end
