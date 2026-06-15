module Admin
  class DashboardController < Admin::ApplicationController
    def index
      @total_members = Member.count
      @active_members = Member.membership_status_active.count
      @guests_this_month = Guest.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
      @referrals_this_month = Referral.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
      @revenue_this_month = FeeCollection.where(payment_date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
      @pending_renewals = Member.membership_status_expired.count + Member.membership_status_pending.count

      @member_growth = Member.group_by_month(:created_at, last: 6, format: "%b").count
      @attendance_chart = MeetingAttendance.group(:attendance_status).count.transform_keys { |k| MeetingAttendance.attendance_statuses.key(k) || k }
      @referral_trend = Referral.group_by_month(:created_at, last: 6, format: "%b").count
      @business_generated = ThankYouSlip.group_by_month(:date, last: 6, format: "%b").sum(:business_value)

      @recent_members = Member.order(created_at: :desc).limit(5)
      @upcoming_meetings = WeeklyMeeting.where("meeting_date >= ?", Date.current).order(:meeting_date).limit(5)
      @pending_renewal_members = Member.where(membership_status: [:expired, :pending]).order(renewal_date: :asc).limit(5)
    end
  end
end
