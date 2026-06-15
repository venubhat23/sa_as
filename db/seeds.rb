puts "Seeding Samarka Association..."

# --- Roles ---
role_data = [
  { name: "Super Admin", description: "Full system access", status: "active", is_system_role: true },
  { name: "Forum Admin", description: "Manages a forum and its chapters", status: "active", is_system_role: false },
  { name: "Chapter President", description: "Leads a chapter", status: "active", is_system_role: false },
  { name: "Vice President", description: "Assists the chapter president", status: "active", is_system_role: false },
  { name: "Secretary", description: "Manages records and communications", status: "active", is_system_role: false },
  { name: "Treasurer", description: "Handles finances and fee collection", status: "active", is_system_role: false },
  { name: "Member", description: "Standard member access", status: "active", is_system_role: true },
  { name: "Guest", description: "Limited guest access", status: "active", is_system_role: true }
]

existing_role_names = Role.pluck(:name)
role_data.reject { |r| existing_role_names.include?(r[:name]) }.each { |r| Role.create!(r) }
roles = Role.all.index_by(&:name)
puts "  Roles: #{Role.count}"

# --- Permissions (batch) ---
MODULES = %w[
  Forums Chapters Regions Locations Members Guests Users Roles
  MembershipPlans Renewals FeeCollections BusinessCategories BusinessSpecialties
  Referrals ThankYouSlips WeeklyMeetings OneToOnes OfficeDarshans Events
  CommitteeRoles CommitteeAssignments Templates Notifications Reports Settings
]

existing_perms = Permission.pluck(:role_id, :module_name).map { |r, m| "#{r}-#{m}" }.to_set
new_perms = []
roles.each do |name, role|
  MODULES.each do |mod|
    next if existing_perms.include?("#{role.id}-#{mod}")
    full = (name == "Super Admin")
    manager = ["Forum Admin", "Chapter President"].include?(name)
    new_perms << {
      role_id: role.id, module_name: mod,
      can_view: full || manager || %w[Members Guests Referrals WeeklyMeetings Reports].include?(mod),
      can_create: full || manager, can_edit: full || manager,
      can_delete: full, can_export: full || manager,
      created_at: Time.current, updated_at: Time.current
    }
  end
end
Permission.insert_all(new_perms) if new_perms.any?
puts "  Permissions: #{Permission.count}"

# --- Sidebar Access (batch) ---
MENU_KEYS = %w[
  dashboard calendar forums chapters regions locations members guests users
  roles permissions sidebar_access membership_plans renewals fee_collections
  business_categories business_specialties referrals thank_you_slips weekly_meetings
  one_to_ones office_darshans events committee_roles committee_assignments
  templates notifications reports settings audit_logs
]
existing_sa = SidebarAccess.pluck(:role_id, :menu_key).map { |r, k| "#{r}-#{k}" }.to_set
new_sa = []
roles.each do |name, role|
  MENU_KEYS.each do |key|
    next if existing_sa.include?("#{role.id}-#{key}")
    enabled = (name == "Super Admin") || %w[dashboard calendar members guests referrals weekly_meetings reports].include?(key) || ["Forum Admin", "Chapter President"].include?(name)
    new_sa << { role_id: role.id, menu_key: key, is_enabled: enabled, created_at: Time.current, updated_at: Time.current }
  end
end
SidebarAccess.insert_all(new_sa) if new_sa.any?
puts "  Sidebar accesses: #{SidebarAccess.count}"

# --- Business Categories ---
cats = ["IT", "Healthcare", "Finance", "Education", "Retail", "Manufacturing", "Real Estate", "Hospitality"]
existing_cats = BusinessCategory.pluck(:name)
cats.reject { |c| existing_cats.include?(c) }.each { |c| BusinessCategory.create!(name: c, status: "active") }
puts "  Business categories: #{BusinessCategory.count}"

# --- Membership Plans ---
MembershipPlan.find_or_create_by!(name: "Annual") { |p| p.duration_months = 12; p.fee_amount = 15000; p.description = "Annual membership"; p.status = "active" }
MembershipPlan.find_or_create_by!(name: "Semi-Annual") { |p| p.duration_months = 6; p.fee_amount = 8000; p.description = "Six month membership"; p.status = "active" }
puts "  Membership plans: #{MembershipPlan.count}"

# --- Forum & Chapter ---
forum = Forum.find_or_create_by!(name: "Samarka Business Forum") { |f| f.code = "SBF"; f.description = "Primary business networking forum"; f.status = "active" }
Chapter.find_or_create_by!(name: "Samarka Main Chapter") { |c| c.code = "SMC"; c.forum_id = forum.id; c.description = "Main chapter"; c.status = "active" }
puts "  Forum & Chapter created"

# --- Admin User ---
admin = User.find_or_initialize_by(email: "admin@samarka.com")
admin.assign_attributes(password: "Admin@123", password_confirmation: "Admin@123", name: "Super Admin", role_id: roles["Super Admin"].id, status: "active")
admin.save!
puts "  Admin user: admin@samarka.com / Admin@123"

# --- Committee Roles ---
["President", "Vice President", "Secretary", "Treasurer", "Membership Chair"].each do |cr|
  CommitteeRole.find_or_create_by!(name: cr) { |c| c.status = "active" }
end

puts "Seeding complete!"
