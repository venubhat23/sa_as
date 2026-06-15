module Admin
  class PermissionsController < Admin::ApplicationController
    MODULES = %w[
      Forums Chapters Regions Locations Members Guests Users Roles
      MembershipPlans Renewals FeeCollections BusinessCategories BusinessSpecialties
      Referrals ThankYouSlips WeeklyMeetings OneToOnes OfficeDarshans Events
      CommitteeRoles CommitteeAssignments Templates Notifications Reports Settings
    ].freeze

    def index
      @roles = Role.order(:name)
      @modules = MODULES
      @permissions = Permission.all.index_by { |p| [p.role_id, p.module_name] }
    end

    def update
      role = Role.find(params[:id])
      perm = Permission.find_or_initialize_by(role_id: role.id, module_name: params[:module_name])
      perm.assign_attributes(
        can_view: params[:can_view] == "true",
        can_create: params[:can_create] == "true",
        can_edit: params[:can_edit] == "true",
        can_delete: params[:can_delete] == "true",
        can_export: params[:can_export] == "true"
      )
      perm.save
      respond_to do |format|
        format.json { render json: { status: "ok" } }
        format.html { redirect_to admin_permissions_path, notice: "Permission updated." }
      end
    end
  end
end
