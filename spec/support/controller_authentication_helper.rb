module ControllerAuthenticationHelper
  def sign_in_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]

    @user = create(:admin)
    sign_in @user
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerAuthenticationHelper, type: :controller
end
