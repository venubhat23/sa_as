puts "Seeding InterConnect..."

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
forum = Forum.find_or_create_by!(name: "InterConnect Business Forum") { |f| f.code = "ICF"; f.description = "Primary business networking forum"; f.status = "active" }
chapter = Chapter.find_or_create_by!(name: "InterConnect Main Chapter") { |c| c.code = "ICM"; c.forum_id = forum.id; c.description = "Main chapter"; c.status = "active" }
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

# =============================================================================
# SAMPLE DATA FOR DASHBOARD
# =============================================================================

categories = BusinessCategory.all.index_by(&:name)
annual_plan = MembershipPlan.find_by(name: "Annual")
semi_plan   = MembershipPlan.find_by(name: "Semi-Annual")

# --- Members ---
members_data = [
  { first_name: "Rajesh",   last_name: "Kumar",   email: "rajesh.kumar@techsolutions.in",   phone: "9845012301", company_name: "TechSolutions Pvt Ltd",     city: "Bangalore", membership_status: :active,  business_category: "IT",           joining_date: 6.months.ago.to_date },
  { first_name: "Priya",    last_name: "Sharma",  email: "priya.sharma@medicarehub.in",     phone: "9845012302", company_name: "Medicare Hub",              city: "Mumbai",    membership_status: :active,  business_category: "Healthcare",   joining_date: 5.months.ago.to_date },
  { first_name: "Amit",     last_name: "Patel",   email: "amit.patel@wealthwise.in",        phone: "9845012303", company_name: "WealthWise Advisors",       city: "Ahmedabad", membership_status: :active,  business_category: "Finance",      joining_date: 5.months.ago.to_date },
  { first_name: "Sneha",    last_name: "Nair",    email: "sneha.nair@learnwithme.in",       phone: "9845012304", company_name: "LearnWithMe Academy",       city: "Kochi",     membership_status: :active,  business_category: "Education",    joining_date: 4.months.ago.to_date },
  { first_name: "Vikram",   last_name: "Singh",   email: "vikram.singh@primerealty.in",     phone: "9845012305", company_name: "Prime Realty Group",        city: "Delhi",     membership_status: :active,  business_category: "Real Estate",  joining_date: 4.months.ago.to_date },
  { first_name: "Meera",    last_name: "Joshi",   email: "meera.joshi@shopstyle.in",        phone: "9845012306", company_name: "ShopStyle Retail",          city: "Pune",      membership_status: :active,  business_category: "Retail",       joining_date: 3.months.ago.to_date },
  { first_name: "Arjun",    last_name: "Mehta",   email: "arjun.mehta@metalcraft.in",       phone: "9845012307", company_name: "MetalCraft Industries",      city: "Surat",     membership_status: :active,  business_category: "Manufacturing",joining_date: 3.months.ago.to_date },
  { first_name: "Kavita",   last_name: "Reddy",   email: "kavita.reddy@grandstay.in",       phone: "9845012308", company_name: "GrandStay Hotels",          city: "Hyderabad", membership_status: :active,  business_category: "Hospitality",  joining_date: 2.months.ago.to_date },
  { first_name: "Suresh",   last_name: "Iyer",    email: "suresh.iyer@cloudpeak.in",        phone: "9845012309", company_name: "CloudPeak Technologies",     city: "Chennai",   membership_status: :active,  business_category: "IT",           joining_date: 2.months.ago.to_date },
  { first_name: "Pooja",    last_name: "Gupta",   email: "pooja.gupta@financeplus.in",      phone: "9845012310", company_name: "FinancePlus Consultants",    city: "Jaipur",    membership_status: :active,  business_category: "Finance",      joining_date: 1.month.ago.to_date  },
  { first_name: "Rohit",    last_name: "Verma",   email: "rohit.verma@buildright.in",       phone: "9845012311", company_name: "BuildRight Properties",      city: "Noida",     membership_status: :pending, business_category: "Real Estate",  joining_date: 2.months.ago.to_date },
  { first_name: "Ananya",   last_name: "Kapoor",  email: "ananya.kapoor@wellnesscare.in",   phone: "9845012312", company_name: "WellnessCare Clinic",        city: "Kolkata",   membership_status: :pending, business_category: "Healthcare",   joining_date: 1.month.ago.to_date  },
  { first_name: "Manoj",    last_name: "Tiwari",  email: "manoj.tiwari@bytecraft.in",       phone: "9845012313", company_name: "ByteCraft Software",         city: "Lucknow",   membership_status: :pending, business_category: "IT",           joining_date: 3.weeks.ago.to_date  },
  { first_name: "Ritu",     last_name: "Saxena",  email: "ritu.saxena@brightminds.in",      phone: "9845012314", company_name: "BrightMinds Institute",      city: "Bhopal",    membership_status: :expired, business_category: "Education",    joining_date: 7.months.ago.to_date },
  { first_name: "Deepak",   last_name: "Nambiar", email: "deepak.nambiar@steelforce.in",    phone: "9845012315", company_name: "SteelForce Manufacturing",   city: "Coimbatore",membership_status: :expired, business_category: "Manufacturing",joining_date: 8.months.ago.to_date },
]

created_members = []
members_data.each_with_index do |data, idx|
  member = Member.find_or_initialize_by(email: data[:email])
  unless member.persisted?
    cat = categories[data[:business_category]]
    member.assign_attributes(
      first_name: data[:first_name],
      last_name: data[:last_name],
      phone: data[:phone],
      company_name: data[:company_name],
      city: data[:city],
      membership_number: "ICM%04d" % (idx + 1),
      membership_status: data[:membership_status],
      business_category: cat,
      forum: forum,
      chapter: chapter,
      membership_plan: (idx.even? ? annual_plan : semi_plan),
      joining_date: data[:joining_date],
      renewal_date: data[:joining_date] + (idx.even? ? 12 : 6).months,
      status: "active"
    )
    member.save!
  end
  created_members << member
end
puts "  Members: #{Member.count}"

active_members = created_members.select { |m| m.membership_status_active? }

# --- Weekly Meetings ---
meeting_types = ["Regular Meeting", "Business Connect", "Power Hour", "Networking Session", "Chapter Meeting"]
venues        = ["InterConnect Hub, Bangalore", "Business Center, Mumbai", "Chapter Office, Delhi", "Convention Hall, Pune", "City Club, Hyderabad"]

meetings = []
(-6..5).each do |i|
  date = i.weeks.from_now.to_date
  mtg = WeeklyMeeting.find_or_initialize_by(meeting_date: date)
  unless mtg.persisted?
    mtg.assign_attributes(
      meeting_type: meeting_types[i.abs % meeting_types.length],
      venue: venues[i.abs % venues.length],
      agenda: "Business networking, referral exchange, and member updates for week #{i.abs + 1}.",
      status: date < Date.current ? "completed" : "scheduled",
      chapter: chapter
    )
    mtg.save!
  end
  meetings << mtg
end
puts "  Weekly meetings: #{WeeklyMeeting.count}"

past_meetings   = meetings.select { |m| m.meeting_date < Date.current }
future_meetings = meetings.select { |m| m.meeting_date >= Date.current }

# --- Meeting Attendances ---
statuses = MeetingAttendance.attendance_statuses.values
past_meetings.each do |mtg|
  active_members.each_with_index do |member, idx|
    MeetingAttendance.find_or_create_by!(weekly_meeting: mtg, member: member) do |a|
      weights = [ :present, :present, :present, :present, :absent, :late, :excused ]
      a.attendance_status = weights[idx % weights.length]
    end
  end
end
puts "  Meeting attendances: #{MeetingAttendance.count}"

# --- Fee Collections ---
payment_modes = ["Cash", "UPI", "Bank Transfer", "Cheque"]
active_members.each_with_index do |member, idx|
  (1..6).each do |months_ago|
    date = months_ago.months.ago.to_date
    FeeCollection.find_or_create_by!(member: member, payment_date: date) do |fc|
      fc.amount       = (idx.even? ? annual_plan.fee_amount : semi_plan.fee_amount) / 6.0
      fc.payment_mode = payment_modes[idx % payment_modes.length]
      fc.receipt_number = "RCP-%05d" % (member.id * 10 + months_ago)
      fc.status       = "completed"
    end
  end
end
puts "  Fee collections: #{FeeCollection.count}"

# --- Referrals ---
referral_statuses = Referral.workflow_statuses.keys
clients = [
  ["Sunita Rao", "9900001111"], ["Harish Bose", "9900002222"], ["Deepa Menon", "9900003333"],
  ["Kiran Shah", "9900004444"], ["Neel Mathur", "9900005555"], ["Tanvi Desai", "9900006666"],
  ["Prasad Kulkarni", "9900007777"], ["Anita Shetty", "9900008888"], ["Vivek Choudhary", "9900009999"],
  ["Rekha Pillai", "9900010000"], ["Sanjay Goel", "9900011111"], ["Nisha Agarwal", "9900012222"],
  ["Tarun Chandra", "9900013333"], ["Preethi Ramesh", "9900014444"], ["Abhinav Roy", "9900015555"],
  ["Savita Bhatt", "9900016666"], ["Ramesh Naidu", "9900017777"], ["Geeta Thakur", "9900018888"],
  ["Lalit More", "9900019999"], ["Fiona D'Souza", "9900020000"]
]

referrals = []
clients.each_with_index do |(client_name, client_phone), idx|
  giver    = active_members[idx % active_members.length]
  receiver = active_members[(idx + 2) % active_members.length]
  next if giver == receiver

  status = referral_statuses[idx % referral_statuses.length]
  ref_date = (idx * 9 + 3).days.ago.to_date

  ref = Referral.find_or_initialize_by(referral_number: "REF-%04d" % (idx + 1))
  unless ref.persisted?
    ref.assign_attributes(
      referral_date: ref_date,
      given_by_member: giver,
      given_to_member: receiver,
      client_name: client_name,
      client_phone: client_phone,
      referral_value: [25000, 50000, 75000, 100000, 150000, 200000][idx % 6],
      workflow_status: status,
      notes: "Referral from #{giver.company_name} for #{client_name}."
    )
    ref.save!
  end
  referrals << ref
end
puts "  Referrals: #{Referral.count}"

# --- Thank You Slips (for won referrals) ---
won_referrals = referrals.select(&:workflow_status_won?)
won_referrals.each_with_index do |ref, idx|
  ThankYouSlip.find_or_create_by!(referral: ref) do |slip|
    slip.business_value      = ref.referral_value * rand(0.6..1.2)
    slip.invoice_number      = "INV-%04d" % (idx + 1)
    slip.client_name         = ref.client_name
    slip.received_by_member  = ref.given_to_member
    slip.thanked_to_member   = ref.given_by_member
    slip.date                = ref.referral_date + rand(7..30).days
    slip.notes               = "Business successfully closed. Thank you!"
  end
end

# Additional thank you slips for dashboard variety
active_members.first(8).each_with_index do |member, idx|
  (1..3).each do |i|
    ThankYouSlip.create!(
      business_value:     [30000, 45000, 60000, 80000, 120000][idx % 5],
      invoice_number:     "INV-EX-%04d" % (idx * 3 + i),
      client_name:        clients[(idx * 3 + i) % clients.length].first,
      received_by_member: member,
      thanked_to_member:  active_members[(idx + 3) % active_members.length],
      date:               (i * 5 + idx * 3).days.ago.to_date,
      notes:              "Business generated through networking."
    ) rescue nil
  end
end
puts "  Thank you slips: #{ThankYouSlip.count}"

# --- Guests ---
guest_data = [
  { name: "Sameer Bhatia",   company: "StartupNest",        phone: "8800001111", status: :attended  },
  { name: "Lata Kulkarni",   company: "KulkarniTech",       phone: "8800002222", status: :registered},
  { name: "Dev Malhotra",    company: "MalhotraRetail",     phone: "8800003333", status: :converted },
  { name: "Poornima Shetty", company: "ShettyMedicals",     phone: "8800004444", status: :follow_up },
  { name: "Nitin Deshpande", company: "DeshpandeFinance",   phone: "8800005555", status: :attended  },
  { name: "Swati Agrawal",   company: "AgrawalHousing",     phone: "8800006666", status: :invited   },
  { name: "Rahul Ganguly",   company: "GangulyManufacturing",phone: "8800007777", status: :attended  },
  { name: "Asha Pillai",     company: "PillaiEducation",    phone: "8800008888", status: :registered},
]

guest_data.each_with_index do |data, idx|
  Guest.find_or_create_by!(phone: data[:phone]) do |g|
    g.name             = data[:name]
    g.company_name     = data[:company]
    g.lifecycle_status = data[:status]
    g.invited_by_member = active_members[idx % active_members.length]
    g.chapter          = chapter
    g.visit_date       = (idx * 5 + 2).days.ago.to_date
    g.created_at       = (idx * 5 + 2).days.ago
  end
end
puts "  Guests: #{Guest.count}"

# --- One-to-One Meetings ---
one_to_one_pairs = [
  [0, 1], [1, 2], [2, 3], [3, 4], [4, 5],
  [5, 6], [6, 7], [7, 8], [0, 5], [2, 7],
  [1, 6], [3, 8]
]

one_to_one_pairs.each_with_index do |(i, j), idx|
  m1 = active_members[i]
  m2 = active_members[j]
  next unless m1 && m2

  meet_date = (idx * 5 - 30).days.from_now.to_date
  OneToOne.find_or_create_by!(member1: m1, member2: m2, meeting_date: meet_date) do |o|
    o.location         = ["Coffee shop", "Office", "Co-working space", "Business center"][idx % 4]
    o.agenda           = "Explore business collaboration between #{m1.company_name} and #{m2.company_name}."
    o.discussion_notes = "Discussed potential referral opportunities and partnership."
    o.action_items     = "Follow up by #{(meet_date + 7).strftime('%d %b')}."
    o.status           = meet_date < Date.current ? "completed" : "scheduled"
  end
end
puts "  One-to-Ones: #{OneToOne.count}"

puts "Seeding complete!"
