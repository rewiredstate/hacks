class EventsController < ApplicationController
  before_filter :find_event, :except => :index

  respond_to :html, :json

  def index
    @events = Event.all
    respond_with @events
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

  def show_centre
    unless @event.use_centres and !params[:centre].blank?
      redirect_to event_path(@event)
      return
    end

    @centre = @event.centres.where(:slug => params[:centre]).first || not_found

    breadcrumbs.add @centre.name, centre_event_path(@event, @centre.slug)

    respond_to do |format|
      format.html {
        }
      format.json {
        }
    end
  end

  private
    def find_event
      @event = Event.find_by_slug(params[:id]) || not_found
      breadcrumbs.add @event.title, event_path(@event)
    end

end
