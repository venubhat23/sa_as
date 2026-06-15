module Admin
  class RolesController < Admin::ApplicationController
    before_action :set_role, only: [:show, :edit, :update, :destroy, :clone]

    def index
      @roles = Role.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show; end

    def new
      @role = Role.new
    end

    def create
      @role = Role.new(role_params)
      if @role.save
        redirect_to admin_role_path(@role), notice: "Role created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @role.update(role_params)
        redirect_to admin_role_path(@role), notice: "Role updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @role.destroy
      redirect_to admin_roles_path, notice: "Role deleted successfully."
    end

    def clone
      new_role = @role.dup
      new_role.name = "#{@role.name} (Copy)"
      new_role.is_system_role = false
      if new_role.save
        @role.permissions.each { |p| new_role.permissions.create(p.attributes.except("id", "role_id", "created_at", "updated_at")) }
        @role.sidebar_accesses.each { |s| new_role.sidebar_accesses.create(s.attributes.except("id", "role_id", "created_at", "updated_at")) }
      end
      redirect_to admin_roles_path, notice: "Role cloned successfully."
    end

    private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :description, :status, :is_system_role)
    end
  end
end
