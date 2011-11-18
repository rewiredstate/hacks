class ProjectsController < ApplicationController
  before_filter :find_project, :except => [:new, :create]
  
  def show
    respond_to do |format|
      format.html { # show.html.erb
        }                          
      format.json { # show.json.rabl
        }
    end
  end                      
  
  private
    def find_project
      @event = Event.find_by_slug(params[:event_id]) || not_found       
      @project = @event.projects.find_by_slug(params[:id]) || not_found    
      
      breadcrumbs.add @event.title, event_url(@event)
      breadcrumbs.add @project.title, event_project_url(@event, @project)
    end
end
