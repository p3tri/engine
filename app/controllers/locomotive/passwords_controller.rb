module Locomotive
  class PasswordsController < ::Devise::PasswordsController

    include Locomotive::Concerns::SiteDispatcherController

    layout '/locomotive/layouts/not_logged_in'

    before_filter :require_site

    helper 'locomotive/base'

    private

    def after_sending_reset_password_instructions_path_for(resource_name)
      new_locomotive_account_session_path
    end

  end
end
