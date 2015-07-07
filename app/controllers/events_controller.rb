class EventsController < ApplicationController
  before_filter :set_breadcrumbs

  def show
    respond_to do |format|
      format.html
      format.json
      format.csv { render :csv => event.projects }
    end
  end

  def show_centre
    unless event.use_centres and !params[:centre].blank?
      redirect_to event_path(event)
      return
    end

    @centre = event.centres.where(:slug => params[:centre]).first || not_found

    breadcrumbs.add @centre.name, centre_event_path(event, @centre.slug)

    respond_to do |format|
      format.html {
        }
      format.json {
        }
    end
  end

  def events
    @events ||= Event.recent_first.all
  end
  helper_method :events

  def event
    if params[:id]
      @event ||= Event.find_by_slug(params[:id]) || not_found
    end
  end
  helper_method :event

private
  def set_breadcrumbs
    if event.present?
      breadcrumbs.add event.title, event_path(event)
    end
  end

end
