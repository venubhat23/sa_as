module Admin
  class DashboardController < Admin::ApplicationController
    def index
      # KPI Cards - Row 1
      @total_members = Member.count
      @active_members = Member.membership_status_active.count
      @guests_this_month = Guest.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
      @referrals_this_month = Referral.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count
      @revenue_this_month = FeeCollection.where(payment_date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
      @pending_renewals = Member.membership_status_expired.count + Member.membership_status_pending.count

      # KPI Cards - Row 2
      @total_revenue = FeeCollection.sum(:amount)
      @won_referrals = Referral.workflow_status_won.count
      @one_to_ones_this_month = OneToOne.where(meeting_date: Date.current.beginning_of_month..Date.current.end_of_month).count
      @active_referrals = Referral.where(workflow_status: [ 0, 1, 2, 3 ]).count

      # Charts - existing
      @member_growth = Member.group_by_month(:created_at, last: 6, format: "%b").count
      @attendance_chart = MeetingAttendance.group(:attendance_status).count.transform_keys { |k| MeetingAttendance.attendance_statuses.key(k)&.humanize || k }
      @referral_trend = Referral.group_by_month(:created_at, last: 6, format: "%b").count
      @business_generated = ThankYouSlip.group_by_month(:date, last: 6, format: "%b").sum(:business_value)

      # Charts - new
      @revenue_trend = FeeCollection.group_by_month(:payment_date, last: 6, format: "%b").sum(:amount)
      @referral_status_chart = Referral.group(:workflow_status).count.transform_keys { |k|
        Referral.workflow_statuses.key(k)&.gsub("_", " ")&.titleize || k.to_s
      }
      @top_categories = BusinessCategory.joins(:members).group("business_categories.name").order(Arel.sql("COUNT(*) DESC")).limit(6).count
      @one_to_one_trend = OneToOne.group_by_month(:meeting_date, last: 6, format: "%b").count

      # Tables - existing
      @recent_members = Member.order(created_at: :desc).limit(5)
      @upcoming_meetings = WeeklyMeeting.where("meeting_date >= ?", Date.current).order(:meeting_date).limit(5)
      @pending_renewal_members = Member.where(membership_status: [ :expired, :pending ]).order(renewal_date: :asc).limit(5)

      # Tables - new
      @recent_referrals = Referral.includes(:given_by_member, :given_to_member).order(created_at: :desc).limit(6)
      @top_business_members = Member
        .joins("INNER JOIN thank_you_slips ON thank_you_slips.received_by_member_id = members.id")
        .select("members.*, SUM(thank_you_slips.business_value) AS total_business")
        .group("members.id")
        .order("total_business DESC")
        .limit(5)
    end
  end
end
