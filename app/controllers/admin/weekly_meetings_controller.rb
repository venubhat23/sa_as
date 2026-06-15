module Admin
  class WeeklyMeetingsController < Admin::ApplicationController
    before_action :set_weekly_meeting, only: [:show, :edit, :update, :destroy]

    def index
      @weekly_meetings = WeeklyMeeting.order(meeting_date: :desc).page(params[:page]).per(25)
    end

    def show
      @attendances = @weekly_meeting.meeting_attendances.includes(:member)
      @guest_attendances = @weekly_meeting.guest_attendances.includes(:guest)
    end

    def new
      @weekly_meeting = WeeklyMeeting.new(meeting_date: Date.current)
    end

    def create
      @weekly_meeting = WeeklyMeeting.new(weekly_meeting_params)
      if @weekly_meeting.save
        redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Meeting created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @weekly_meeting.update(weekly_meeting_params)
        redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Meeting updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @weekly_meeting.destroy
      redirect_to admin_weekly_meetings_path, notice: "Meeting deleted successfully."
    end

    private

    def set_weekly_meeting
      @weekly_meeting = WeeklyMeeting.find(params[:id])
    end

    def weekly_meeting_params
      params.require(:weekly_meeting).permit(:chapter_id, :meeting_date, :meeting_type, :venue, :agenda, :status, :notes)
    end
  end
end
