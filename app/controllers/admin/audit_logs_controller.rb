module Admin
  class AuditLogsController < Admin::ApplicationController
    def index
      @audit_logs = AuditLog.order(created_at: :desc).page(params[:page]).per(25)
    end
  end
end
