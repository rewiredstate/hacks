class Admin::EventsController < Admin::BaseController
  before_filter do
    breadcrumbs.add "Events", admin_events_path
  end

  def create
    event.assign_attributes(event_params)

    if event.save
      redirect_to admin_events_path
    else
      render action: :new
    end
  end

  def update
    if event.update_attributes(event_params)
      redirect_to admin_events_path
    else
      render action: :edit
    end
  end

  def destroy
    event.destroy
    redirect_to admin_events_path
  end

  def event
    if params.key?(:id)
      @event ||= Event.find_by_slug(params[:id])
    else
      @event ||= Event.new
    end
  end
  helper_method :event

  def events
    @events ||= Event.all
  end
  helper_method :events

  private
    def event_params
      params.fetch(:event, {}).permit(:title, :slug, :hashtag, :use_centres,
                :active, :url, :enable_project_creation, :start_date,
                centres_attributes: [ :id, :name, :slug ],
                award_categories_attributes: [ :id, :title, :description, :format, :level, :featured, :_destroy ])
    end

end
