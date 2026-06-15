module Admin
  class ReferralsController < Admin::ApplicationController
    before_action :set_referral, only: [:show, :edit, :update, :destroy, :update_workflow]

    def index
      @referrals = Referral.order(created_at: :desc)
      @referrals = @referrals.where(workflow_status: params[:workflow_status]) if params[:workflow_status].present?
      @referrals = @referrals.page(params[:page]).per(25)
      @total_value = Referral.sum(:referral_value)
      @won_count = Referral.workflow_status_won.count
    end

    def given
      @referrals = Referral.order(created_at: :desc).page(params[:page]).per(25)
      render :index
    end

    def received
      @referrals = Referral.order(created_at: :desc).page(params[:page]).per(25)
      render :index
    end

    def pipeline
      @pipeline = Referral.group(:workflow_status).count
    end

    def show; end

    def new
      @referral = Referral.new(referral_date: Date.current, referral_number: "REF-#{Time.now.to_i}")
    end

    def create
      @referral = Referral.new(referral_params)
      if @referral.save
        redirect_to admin_referral_path(@referral), notice: "Referral created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @referral.update(referral_params)
        redirect_to admin_referral_path(@referral), notice: "Referral updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @referral.destroy
      redirect_to admin_referrals_path, notice: "Referral deleted successfully."
    end

    def update_workflow
      @referral.update(workflow_status: params[:workflow_status])
      redirect_to admin_referral_path(@referral), notice: "Workflow status updated."
    end

    private

    def set_referral
      @referral = Referral.find(params[:id])
    end

    def referral_params
      params.require(:referral).permit(:referral_number, :referral_date, :given_by_member_id,
        :given_to_member_id, :client_name, :client_phone, :referral_value, :notes, :workflow_status)
    end
  end
end
