module ApplicationHelper
  STATUS_COLORS = {
    "active" => "success", "inactive" => "secondary", "expired" => "danger",
    "suspended" => "warning", "pending" => "warning", "completed" => "success",
    "scheduled" => "info", "upcoming" => "info", "cancelled" => "danger",
    "won" => "success", "lost" => "danger", "converted" => "success",
    "paid" => "success", "unpaid" => "danger", "present" => "success", "absent" => "danger"
  }.freeze

  def status_badge(status)
    return "".html_safe if status.blank?
    color = STATUS_COLORS[status.to_s.downcase] || "primary"
    content_tag(:span, status.to_s.titleize, class: "badge bg-#{color}")
  end

  def workflow_badge(status)
    colors = {
      "new_referral" => "secondary", "contacted" => "info", "qualified" => "primary",
      "proposal_submitted" => "warning", "won" => "success", "lost" => "danger"
    }
    color = colors[status.to_s] || "secondary"
    content_tag(:span, status.to_s.titleize, class: "badge bg-#{color}")
  end

  def page_title(title)
    content_for(:title) { "#{title} | InterConnect" }
    title
  end

  def inr(amount)
    "₹#{number_with_delimiter(amount.to_i)}"
  end

  def admin_new_path_for(singular)
    send("new_admin_#{singular}_path")
  end

  def display_attr(record, attr)
    val = record.public_send(attr)
    return content_tag(:span, "—", class: "text-muted") if val.blank?
    case val
    when true then content_tag(:span, "Yes", class: "badge bg-success")
    when false then content_tag(:span, "No", class: "badge bg-secondary")
    when Date then val.strftime("%d %b %Y")
    when Time, ActiveSupport::TimeWithZone then val.strftime("%d %b %Y %H:%M")
    else val.to_s
    end
  end
end
