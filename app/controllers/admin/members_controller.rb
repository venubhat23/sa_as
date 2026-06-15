module Admin
  class MembersController < Admin::ApplicationController
    before_action :set_member, only: [:show, :edit, :update, :destroy, :suspend, :transfer, :renew, :referral_history, :attendance_history]

    def index
      @members = Member.order(created_at: :desc)
      @members = @members.by_chapter(params[:chapter_id]) if params[:chapter_id].present?
      @members = @members.by_category(params[:business_category_id]) if params[:business_category_id].present?
      @members = @members.by_status(params[:membership_status]) if params[:membership_status].present?
      @members = @members.page(params[:page]).per(25)

      @total_count = Member.count
      @active_count = Member.membership_status_active.count
      @expired_count = Member.membership_status_expired.count
      @pending_count = Member.membership_status_pending.count
      @chapters = Chapter.all
      @categories = BusinessCategory.all
    end

    def show
      @tab = params[:tab] || "basic_info"
    end

    def new
      @member = Member.new
    end

    def create
      @member = Member.new(member_params)
      if @member.save
        redirect_to admin_member_path(@member), notice: "Member created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @member.update(member_params)
        redirect_to admin_member_path(@member), notice: "Member updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @member.destroy
      redirect_to admin_members_path, notice: "Member deleted successfully."
    end

    def suspend
      @member.update(membership_status: :suspended)
      redirect_to admin_member_path(@member), notice: "Member suspended."
    end

    def transfer
      @member.update(chapter_id: params[:chapter_id]) if params[:chapter_id].present?
      redirect_to admin_member_path(@member), notice: "Member transferred."
    end

    def renew
      @member.update(membership_status: :active, renewal_date: Date.current + 1.year)
      redirect_to admin_member_path(@member), notice: "Membership renewed."
    end

    def referral_history
      @referrals_given = @member.referrals_given.order(created_at: :desc)
      @referrals_received = @member.referrals_received.order(created_at: :desc)
    end

    def attendance_history
      @attendances = @member.meeting_attendances.includes(:weekly_meeting).order(created_at: :desc)
    end

    private

    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.require(:member).permit(
        :user_id, :membership_number, :chapter_id, :forum_id,
        :first_name, :last_name, :phone, :email, :dob, :address, :city, :state, :pincode,
        :company_name, :gst_number, :pan_number, :business_category_id, :business_specialty_id,
        :website, :linkedin_url, :photo,
        :membership_plan_id, :joining_date, :renewal_date, :membership_status,
        :pan_document, :gst_document, :aadhar_document, :business_registration_document, :status
      )
    end
  end
end
