module Admin
  class GuestsController < Admin::ApplicationController
    before_action :set_guest, only: [:show, :edit, :update, :destroy, :convert_to_member]

    def index
      @guests = Guest.order(created_at: :desc)
      @guests = @guests.where(lifecycle_status: params[:lifecycle_status]) if params[:lifecycle_status].present?
      @guests = @guests.page(params[:page]).per(25)
      @total_count = Guest.count
      @converted_count = Guest.lifecycle_status_converted.count
    end

    def show; end

    def new
      @guest = Guest.new
    end

    def create
      @guest = Guest.new(guest_params)
      if @guest.save
        redirect_to admin_guest_path(@guest), notice: "Guest created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @guest.update(guest_params)
        redirect_to admin_guest_path(@guest), notice: "Guest updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @guest.destroy
      redirect_to admin_guests_path, notice: "Guest deleted successfully."
    end

    def convert_to_member
      member = Member.create(
        first_name: @guest.name, phone: @guest.phone, email: @guest.email,
        company_name: @guest.company_name, business_category_id: @guest.business_category_id,
        chapter_id: @guest.chapter_id, joining_date: Date.current, membership_status: :active
      )
      @guest.update(lifecycle_status: :converted, converted_at: Time.current, converted_member_id: member.id)
      redirect_to admin_member_path(member), notice: "Guest converted to member."
    end

    private

    def set_guest
      @guest = Guest.find(params[:id])
    end

    def guest_params
      params.require(:guest).permit(:name, :phone, :email, :company_name, :business_category_id,
                                    :invited_by_member_id, :chapter_id, :lifecycle_status, :visit_date, :notes)
    end
  end
end
