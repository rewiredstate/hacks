class EventsController < ApplicationController
  before_filter :find_event, :except => :index  
                      
  def index
    redirect_to event_url(Event.first)
  end
  
  def show
    respond_to do |format|
      format.html { # show.html.erb
        }                          
      format.json { # show.json.rabl
        }
    end
  end                      
  
  private
    def find_event
      @event = Event.find_by_slug(params[:id]) || not_found     
      breadcrumbs.add @event.title, event_url(@event)
    end        

end
