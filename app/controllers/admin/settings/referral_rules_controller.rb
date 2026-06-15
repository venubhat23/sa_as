module Admin
  module Settings
    class ReferralRulesController < Admin::ApplicationController
      before_action :set_rule, only: [:show, :edit, :update, :destroy]

      def index
        @referral_rules = ReferralRule.order(created_at: :desc).page(params[:page]).per(25)
      end

      def show; end
      def new; @referral_rule = ReferralRule.new; end

      def create
        @referral_rule = ReferralRule.new(rule_params)
        if @referral_rule.save
          redirect_to admin_settings_referral_rules_path, notice: "Rule created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit; end

      def update
        if @referral_rule.update(rule_params)
          redirect_to admin_settings_referral_rules_path, notice: "Rule updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @referral_rule.destroy
        redirect_to admin_settings_referral_rules_path, notice: "Rule deleted."
      end

      private

      def set_rule
        @referral_rule = ReferralRule.find(params[:id])
      end

      def rule_params
        params.require(:referral_rule).permit(:rule_type, :value, :description, :status)
      end
    end
  end
end
