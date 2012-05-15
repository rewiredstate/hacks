class Admin::AwardCategoriesController < Admin::BaseController

  inherit_resources

  belongs_to :event, :finder => :find_by_slug, :param => :event_id
  actions :all, :except => :show

  before_filter do
    breadcrumbs.add "Events", admin_events_path
    breadcrumbs.add parent.title, edit_parent_path
    breadcrumbs.add "Awards", collection_path
  end

end