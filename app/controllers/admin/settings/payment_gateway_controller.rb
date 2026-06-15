module Admin
  module Settings
    class PaymentGatewayController < Admin::ApplicationController
      def index
        @gateways = PaymentGatewaySetting.all
        @gateway = PaymentGatewaySetting.first_or_initialize
      end

      def update
        @gateway = PaymentGatewaySetting.first_or_initialize
        @gateway.update(gateway_params)
        redirect_to admin_settings_payment_gateway_path, notice: "Payment gateway settings saved."
      end

      private

      def gateway_params
        params.require(:payment_gateway_setting).permit(:gateway_name, :api_key, :api_secret, :is_active, :environment)
      end
    end
  end
end
