module Admin
  module Settings
    class GeneralController < Admin::ApplicationController
      def index
        @settings = GeneralSetting.all
      end

      def update
        (params[:settings] || {}).each do |key, value|
          setting = GeneralSetting.find_or_initialize_by(key: key)
          setting.value = value
          setting.save
        end
        redirect_to admin_settings_general_path, notice: "Settings saved."
      end
    end
  end
end
