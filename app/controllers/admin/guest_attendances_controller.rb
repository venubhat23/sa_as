module Admin
  class GuestAttendancesController < Admin::ApplicationController
    before_action :set_meeting

    def index
      @guest_attendances = @weekly_meeting.guest_attendances.includes(:guest)
      @guests = Guest.all
    end

    def create
      @guest_attendance = @weekly_meeting.guest_attendances.new(attendance_params)
      @guest_attendance.save
      redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Guest attendance recorded."
    end

    def update
      @guest_attendance = @weekly_meeting.guest_attendances.find(params[:id])
      @guest_attendance.update(attendance_params)
      redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Guest attendance updated."
    end

    private

    def set_meeting
      @weekly_meeting = WeeklyMeeting.find(params[:weekly_meeting_id])
    end

    def attendance_params
      params.require(:guest_attendance).permit(:guest_id, :attendance_status, :check_in_time)
    end
  end
end
