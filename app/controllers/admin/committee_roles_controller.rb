module Admin
  class CommitteeRolesController < Admin::ApplicationController
    before_action :set_committee_role, only: [:show, :edit, :update, :destroy]

    def index
      @committee_roles = CommitteeRole.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @committee_role = CommitteeRole.new
    end

    def create
      @committee_role = CommitteeRole.new(committee_role_params)
      if @committee_role.save
        redirect_to admin_committee_role_path(@committee_role), notice: "Committee Role created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @committee_role.update(committee_role_params)
        redirect_to admin_committee_role_path(@committee_role), notice: "Committee Role updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @committee_role.destroy
      redirect_to admin_committee_roles_path, notice: "Committee Role deleted successfully."
    end

    private

    def set_committee_role
      @committee_role = CommitteeRole.find(params[:id])
    end

    def committee_role_params
      params.require(:committee_role).permit(:name, :description, :status)
    end
  end
end
