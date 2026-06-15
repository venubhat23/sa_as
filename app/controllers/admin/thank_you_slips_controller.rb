module Admin
  class ThankYouSlipsController < Admin::ApplicationController
    before_action :set_thank_you_slip, only: [:show, :edit, :update, :destroy]

    def index
      @thank_you_slips = ThankYouSlip.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @thank_you_slip = ThankYouSlip.new
    end

    def create
      @thank_you_slip = ThankYouSlip.new(thank_you_slip_params)
      if @thank_you_slip.save
        redirect_to admin_thank_you_slip_path(@thank_you_slip), notice: "Thank You Slip created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @thank_you_slip.update(thank_you_slip_params)
        redirect_to admin_thank_you_slip_path(@thank_you_slip), notice: "Thank You Slip updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @thank_you_slip.destroy
      redirect_to admin_thank_you_slips_path, notice: "Thank You Slip deleted successfully."
    end

    private

    def set_thank_you_slip
      @thank_you_slip = ThankYouSlip.find(params[:id])
    end

    def thank_you_slip_params
      params.require(:thank_you_slip).permit(:referral_id, :business_value, :invoice_number, :client_name, :received_by_member_id, :thanked_to_member_id, :date, :notes)
    end
  end
end
