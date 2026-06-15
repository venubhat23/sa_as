module Admin
  module Settings
    class AttendanceRulesController < Admin::ApplicationController
      before_action :set_rule, only: [:show, :edit, :update, :destroy]

      def index
        @attendance_rules = AttendanceRule.order(created_at: :desc).page(params[:page]).per(25)
      end

      def show; end
      def new; @attendance_rule = AttendanceRule.new; end

      def create
        @attendance_rule = AttendanceRule.new(rule_params)
        if @attendance_rule.save
          redirect_to admin_settings_attendance_rules_path, notice: "Rule created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit; end

      def update
        if @attendance_rule.update(rule_params)
          redirect_to admin_settings_attendance_rules_path, notice: "Rule updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @attendance_rule.destroy
        redirect_to admin_settings_attendance_rules_path, notice: "Rule deleted."
      end

      private

      def set_rule
        @attendance_rule = AttendanceRule.find(params[:id])
      end

      def rule_params
        params.require(:attendance_rule).permit(:rule_type, :value, :description, :status)
      end
    end
  end
end
