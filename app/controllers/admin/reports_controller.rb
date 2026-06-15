module Admin
  class ReportsController < Admin::ApplicationController
    def index
      @members_by_status = Member.group(:membership_status).count.transform_keys { |k| Member.membership_statuses.key(k) || k }
      @members_by_chapter = Member.joins(:chapter).group("chapters.name").count
      @referral_trend = Referral.group_by_month(:created_at, last: 6, format: "%b").count
      @revenue_trend = FeeCollection.group_by_month(:payment_date, last: 6, format: "%b").sum(:amount)
      @guest_conversion = Guest.group(:lifecycle_status).count.transform_keys { |k| Guest.lifecycle_statuses.key(k) || k }
    end

    def members_report
      @members = Member.includes(:chapter, :business_category).order(created_at: :desc).page(params[:page]).per(50)
      @by_status = Member.group(:membership_status).count.transform_keys { |k| Member.membership_statuses.key(k) || k }
    end

    def attendance_report
      @by_status = MeetingAttendance.group(:attendance_status).count.transform_keys { |k| MeetingAttendance.attendance_statuses.key(k) || k }
      @attendance_trend = MeetingAttendance.group_by_month(:created_at, last: 6, format: "%b").count
    end

    def referral_report
      @by_status = Referral.group(:workflow_status).count.transform_keys { |k| Referral.workflow_statuses.key(k) || k }
      @trend = Referral.group_by_month(:created_at, last: 6, format: "%b").count
      @total_value = Referral.sum(:referral_value)
    end

    def revenue_report
      @revenue_trend = FeeCollection.group_by_month(:payment_date, last: 12, format: "%b").sum(:amount)
      @by_mode = FeeCollection.group(:payment_mode).sum(:amount)
      @total = FeeCollection.sum(:amount)
    end

    def guest_conversion_report
      @by_status = Guest.group(:lifecycle_status).count.transform_keys { |k| Guest.lifecycle_statuses.key(k) || k }
      @trend = Guest.group_by_month(:created_at, last: 6, format: "%b").count
      @converted = Guest.lifecycle_status_converted.count
      @total = Guest.count
    end
  end
end
