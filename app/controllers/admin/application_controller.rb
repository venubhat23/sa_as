module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!

    layout "application"
  end
end
