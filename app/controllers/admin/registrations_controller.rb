class Admin::RegistrationsController < Devise::RegistrationsController
  before_filter do
    breadcrumbs.add "Admin", admin_root_path
  end
end