module Admin
  class MembershipPlansController < Admin::ApplicationController
    before_action :set_membership_plan, only: [:show, :edit, :update, :destroy]

    def index
      @membership_plans = MembershipPlan.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @membership_plan = MembershipPlan.new
    end

    def create
      @membership_plan = MembershipPlan.new(membership_plan_params)
      if @membership_plan.save
        redirect_to admin_membership_plan_path(@membership_plan), notice: "Membership Plan created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @membership_plan.update(membership_plan_params)
        redirect_to admin_membership_plan_path(@membership_plan), notice: "Membership Plan updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @membership_plan.destroy
      redirect_to admin_membership_plans_path, notice: "Membership Plan deleted successfully."
    end

    private

    def set_membership_plan
      @membership_plan = MembershipPlan.find(params[:id])
    end

    def membership_plan_params
      params.require(:membership_plan).permit(:name, :duration_months, :fee_amount, :description, :status)
    end
  end
end
