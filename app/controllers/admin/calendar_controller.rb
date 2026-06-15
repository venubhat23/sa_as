module Admin
  class CalendarController < Admin::ApplicationController
    def index
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @start_date = @date.beginning_of_month.beginning_of_week(:sunday)
      @end_date = @date.end_of_month.end_of_week(:sunday)
      @meetings = WeeklyMeeting.where(meeting_date: @start_date..@end_date)
      @events = Event.where(start_date: @start_date.beginning_of_day..@end_date.end_of_day)
      @renewals = Member.where(renewal_date: @start_date..@end_date)
    end
  end
end
