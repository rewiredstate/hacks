class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :events_breadcrumb

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def events_breadcrumb
    # breadcrumbs.add "Events", "http://rewiredstate.org/events"
    breadcrumbs.add "Hacks", root_path
  end
end
