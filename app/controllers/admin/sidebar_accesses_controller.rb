module Admin
  class SidebarAccessesController < Admin::ApplicationController
    MENU_KEYS = %w[
      dashboard calendar forums chapters regions locations members guests users
      roles permissions sidebar_access membership_plans renewals fee_collections
      business_categories business_specialties referrals thank_you_slips weekly_meetings
      one_to_ones office_darshans events committee_roles committee_assignments
      templates notifications reports settings audit_logs
    ].freeze

    def index
      @roles = Role.order(:name)
      @menu_keys = MENU_KEYS
      @accesses = SidebarAccess.all.index_by { |s| [s.role_id, s.menu_key] }
    end

    def update
      role = Role.find(params[:id])
      access = SidebarAccess.find_or_initialize_by(role_id: role.id, menu_key: params[:menu_key])
      access.is_enabled = params[:is_enabled] == "true"
      access.save
      respond_to do |format|
        format.json { render json: { status: "ok" } }
        format.html { redirect_to admin_sidebar_accesses_path, notice: "Sidebar access updated." }
      end
    end
  end
end
