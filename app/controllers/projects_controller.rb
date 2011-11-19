class ProjectsController < ApplicationController
  before_filter :find_event
  before_filter :find_project, :except => [:new, :create]
        
  def new
    @project = @event.projects.build
    
    breadcrumbs.add "New project", new_event_project_url(@event, @project)
  end
  
  def create                                             
    @project = @event.projects.build(params[:project])
    
    if @project.save
      flash[:notice] = 'Your project has been created.'
      redirect_to event_project_url(@event, @project)
    else                                              
      breadcrumbs.add "New project", new_event_project_url(@event, @project)
      render :action => :new
    end
  end
  
  def show
    respond_to do |format|
      format.html { # show.html.erb
        }                          
      format.json { # show.json.rabl
        }
    end
  end     
  
  def edit
    # edit.html.erb        
    breadcrumbs.add "Edit project", edit_event_project_url(@event, @project)
  end                 

  def update                 
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Your project has been updated.'
      redirect_to event_project_url(@event,@project)
    else
      breadcrumbs.add "Edit project", edit_event_project_url(@event, @project)
      render :action => :edit
    end
  end
  
  private           
    def find_event
      @event = Event.find_by_slug(params[:event_id]) || not_found          
      breadcrumbs.add @event.title, event_url(@event)
    end
    
    def find_project      
      @project = @event.projects.find_by_slug(params[:id]) || not_found    
      breadcrumbs.add @project.title, event_project_url(@event, @project)
    end
end
