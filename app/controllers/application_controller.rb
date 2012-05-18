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

  private
    def after_sign_out_path_for(resource_or_scope)
      new_admin_session_path
    end
end
