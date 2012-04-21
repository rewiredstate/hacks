class EventsController < ApplicationController
  before_filter :find_event, :except => :index

  def index
    @events = Event.all
  end

  def show
    respond_to do |format|
      format.html { # show.html.erb
        }
      format.json { # show.json.rabl
        }
      format.csv { render :csv => @event.projects }
    end
  end

  private
    def find_event
      @event = Event.find_by_slug(params[:id]) || not_found
      breadcrumbs.add @event.title, event_url(@event)
    end

end
