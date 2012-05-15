class Admin::BaseController < ApplicationController

  before_filter :authenticate_admin!
  before_filter do
    breadcrumbs.add "Admin", admin_root_path
  end

end