class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  def has_sidebar_permission?(key)
    return true if current_user&.role&.name == "Super Admin"
    SidebarAccess.where(role_id: current_user&.role_id, menu_key: key, is_enabled: true).exists?
  end
  helper_method :has_sidebar_permission?

  def has_permission?(module_name, action)
    return true if current_user&.role&.name == "Super Admin"
    Permission.where(role_id: current_user&.role_id, module_name: module_name, "can_#{action}": true).exists?
  end
  helper_method :has_permission?
end
