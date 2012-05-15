class Admin::EventsController < Admin::BaseController

  inherit_resources

  actions :all, :except => :show

  before_filter do
    breadcrumbs.add "Events", collection_path
  end

  protected
    def resource
      @event ||= Event.find_by_slug(params[:id])
    end

end