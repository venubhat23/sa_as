module Admin
  class MembershipRenewalsController < Admin::ApplicationController
    before_action :set_membership_renewal, only: [:show, :edit, :update, :destroy]

    def index
      @membership_renewals = MembershipRenewal.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @membership_renewal = MembershipRenewal.new
    end

    def create
      @membership_renewal = MembershipRenewal.new(membership_renewal_params)
      if @membership_renewal.save
        redirect_to admin_membership_renewal_path(@membership_renewal), notice: "Membership Renewal created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @membership_renewal.update(membership_renewal_params)
        redirect_to admin_membership_renewal_path(@membership_renewal), notice: "Membership Renewal updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @membership_renewal.destroy
      redirect_to admin_membership_renewals_path, notice: "Membership Renewal deleted successfully."
    end

    private

    def set_membership_renewal
      @membership_renewal = MembershipRenewal.find(params[:id])
    end

    def membership_renewal_params
      params.require(:membership_renewal).permit(:member_id, :plan_id, :renewal_date, :expiry_date, :amount, :payment_status, :notes)
    end
  end
end
