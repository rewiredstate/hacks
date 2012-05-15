class Admin::ProjectsController < Admin::BaseController

  inherit_resources

  belongs_to :event, :finder => :find_by_slug, :param => :event_id
  with_role :admin
  actions :all, :except => [:show, :new, :create]

  before_filter do
    breadcrumbs.add "Events", admin_events_path
    breadcrumbs.add parent.title, edit_parent_path
    breadcrumbs.add "Projects", collection_path
  end

  before_filter :only => :update do
    resource.managing = true
  end

  protected
    def resource
      @project ||= @event.projects.find_by_slug(params[:id])
    end

end