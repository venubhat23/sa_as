module Admin
  class MeetingAttendancesController < Admin::ApplicationController
    before_action :set_meeting

    def index
      @attendances = @weekly_meeting.meeting_attendances.includes(:member)
      @members = Member.all
    end

    def create
      @attendance = @weekly_meeting.meeting_attendances.new(attendance_params)
      @attendance.save
      redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Attendance recorded."
    end

    def update
      @attendance = @weekly_meeting.meeting_attendances.find(params[:id])
      @attendance.update(attendance_params)
      redirect_to admin_weekly_meeting_path(@weekly_meeting), notice: "Attendance updated."
    end

    private

    def set_meeting
      @weekly_meeting = WeeklyMeeting.find(params[:weekly_meeting_id])
    end

    def attendance_params
      params.require(:meeting_attendance).permit(:member_id, :attendance_status, :check_in_time, :method)
    end
  end
end
