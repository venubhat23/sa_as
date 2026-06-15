# Samarka Association

A Role-Based Access Control (RBAC) **Business Networking Forum ERP** (similar to BNI), built with Ruby on Rails 8.

---

## 1. Project Overview

Samarka Association is an admin/ERP platform for managing a multi-chapter business networking organization. It tracks members, guests, referrals, business generated (thank-you slips), weekly meetings & attendance, networking activities, events, committees, communication templates, and reporting — all gated behind a configurable role/permission system.

## 2. Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 8.0 |
| Language | Ruby 3.2 |
| Database | PostgreSQL |
| Auth | Devise |
| Authorization | CanCanCan + custom RBAC (Permission / SidebarAccess) |
| Pagination | Kaminari (25/page) |
| Charts | Chartkick + Chart.js + Groupdate |
| Frontend | Bootstrap 5, Bootstrap Icons, Font Awesome, Select2 (all via CDN) |
| Asset pipeline | Propshaft |
| JS | Import maps (Hotwire Turbo + Stimulus) |
| Fonts | Poppins |

## 3. Module List

- **Organization**: Forums, Chapters, Regions, Locations
- **User Management**: Members (multi-tab profile), Guests (lifecycle + conversion), User Accounts
- **Roles & Permissions**: Roles (with clone), Permission matrix, Sidebar Access control
- **Membership**: Membership Plans, Renewals, Fee Collection
- **Business Directory**: Categories, Specialties
- **Referrals**: Referrals (workflow pipeline), Thank You Slips
- **Networking**: One-To-One, Office Darshan
- **Attendance / Meetings**: Weekly Meetings, Meeting Attendance, Guest Attendance
- **Events**: Events, Event Registrations
- **Committee**: Committee Roles, Committee Assignments
- **Communication**: Email / SMS / WhatsApp Templates, Notifications
- **Reports**: Dashboard analytics, Members, Attendance, Referral, Revenue, Guest Conversion
- **Settings**: General, Payment Gateway, Attendance Rules, Referral Rules
- **Audit Logs**, **Calendar**

## 4. Database

**Render.com PostgreSQL (Production/Development)**

| Field | Value |
|-------|-------|
| Database | markettincer_dbssdd |
| Username | markettincer_dbssdd_user |
| Host (External) | dpg-d8ne3n7lk1mc739l52eg-a.oregon-postgres.render.com |
| External URL | `postgresql://markettincer_dbssdd_user:V2j1emW4JjaX1aeMy123cg1X4ExKLzXw@dpg-d8ne3n7lk1mc739l52eg-a.oregon-postgres.render.com/markettincer_dbssdd` |

The database URL is configured directly in `config/database.yml`.

## 5. Setup Instructions

```bash
cd samarka-association

# 1. Install gems
bundle install

# 2. Run migrations (DB is pre-configured to Render PostgreSQL)
bin/rails db:migrate SCHEMA=/dev/null

# 3. Seed initial data
bin/rails db:seed

# 4. Run
bin/rails server
# visit http://localhost:3000  (redirects to /users/sign_in)
```

## 5. Default Credentials

| Field | Value |
|-------|-------|
| Email | `admin@samarka.com` |
| Password | `Admin@123` |
| Role | Super Admin (full access) |

## 6. Architecture Overview

- **`ApplicationController`** enforces `authenticate_user!` and exposes two RBAC helpers used in views/controllers:
  - `has_sidebar_permission?(menu_key)` — checks `SidebarAccess` for the current user's role.
  - `has_permission?(module_name, action)` — checks `Permission.can_<action>` for the current user's role.
  - `Super Admin` short-circuits both to `true`.
- All admin functionality lives under the **`Admin::`** namespace (`app/controllers/admin/...`), inheriting from `Admin::ApplicationController`.
- **RBAC data model**: a `User` belongs to a `Role`; a `Role` has many `Permission` rows (one per module, with `can_view/create/edit/delete/export` booleans) and many `SidebarAccess` rows (one per menu key, `is_enabled`).
- **Permission matrix** (`/admin/permissions`) and **Sidebar Access** (`/admin/sidebar_accesses`) are edited inline via AJAX (`fetch` PATCH, JSON response).
- Enums: `Member#membership_status`, `Guest#lifecycle_status`, `Referral#workflow_status`, `MeetingAttendance#attendance_status`.
- Layout: fixed gradient header (70px) + `modern-sidebar` (dark, collapsible sections), toast flash notifications, sidebar scroll persistence.

## 7. Database Schema Summary

35 tables (+ `users`). Key entities and notable foreign keys:

- `users` (devise + `role_id`, `name`, `phone`, `status`)
- `roles`, `permissions` (`role_id`), `sidebar_accesses` (`role_id`)
- `forums`, `chapters` (`forum_id`), `regions`, `locations` (`region_id`, `chapter_id`)
- `members` (`user_id`, `chapter_id`, `forum_id`, `business_category_id`, `business_specialty_id`, `membership_plan_id`) — full profile + KYC document URLs
- `guests` (`invited_by_member_id`, `chapter_id`, `converted_member_id`)
- `membership_plans`, `membership_renewals` (`member_id`, `plan_id`), `fee_collections` (`member_id`, `renewal_id`)
- `business_categories`, `business_specialties` (`business_category_id`)
- `referrals` (`given_by_member_id`, `given_to_member_id`), `thank_you_slips` (`referral_id`, `received_by_member_id`, `thanked_to_member_id`)
- `weekly_meetings` (`chapter_id`), `meeting_attendances` (`weekly_meeting_id`, `member_id`), `guest_attendances` (`weekly_meeting_id`, `guest_id`)
- `one_to_ones` (`member1_id`, `member2_id`), `office_darshans` (`host_member_id`), `office_darshan_visitors`
- `events`, `event_registrations` (`event_id`, `member_id`)
- `committee_roles`, `committee_assignments` (`member_id`, `committee_role_id`, `chapter_id`)
- `email_templates`, `sms_templates`, `whatsapp_templates`, `notifications` (`user_id`)
- `audit_logs` (`user_id`), `general_settings`, `payment_gateway_settings`, `attendance_rules`, `referral_rules`

## 8. Routes / Endpoints

All app routes are under the `admin` namespace. Highlights:

- `GET /admin/dashboard`, `GET /admin/calendar`
- Full REST CRUD for: forums, chapters, regions, locations, members, guests, users, roles, membership_plans, membership_renewals, fee_collections, business_categories, business_specialties, referrals, thank_you_slips, one_to_ones, office_darshans, weekly_meetings, events, committee_roles, committee_assignments, email_templates, sms_templates, whatsapp_templates, notifications
- Member member-routes: `PATCH suspend`, `PATCH transfer`, `PATCH renew`, `GET referral_history`, `GET attendance_history`
- Guest: `PATCH convert_to_member`
- Role: `POST clone`
- Referral: `PATCH update_workflow`; collection `given`, `received`, `pipeline`
- Permissions: `GET index`, `PATCH update` (matrix, JSON)
- Sidebar accesses: `GET index`, `PATCH update` (toggle, JSON)
- Nested: `weekly_meetings/:id/meeting_attendances`, `/guest_attendances`; `events/:id/event_registrations`
- Reports: `/admin/reports`, `/reports/members`, `/reports/attendance`, `/reports/referrals`, `/reports/revenue`, `/reports/guest_conversion`
- Settings: `/admin/settings/general`, `/payment_gateway`, `/attendance_rules`, `/referral_rules`
- `GET /admin/audit_logs`

## 9. Role Permissions Matrix (seeded defaults)

Seeded roles: **Super Admin, Forum Admin, Chapter President, Vice President, Secretary, Treasurer, Member, Guest**.

| Role | View | Create | Edit | Delete | Export |
|------|:----:|:------:|:----:|:------:|:------:|
| Super Admin | all | all | all | all | all |
| Forum Admin | all | all | all | — | all |
| Chapter President | all | all | all | — | all |
| Other roles | core modules* | — | — | — | — |

\* core modules = Members, Guests, Referrals, WeeklyMeetings, Reports.

Permissions are fully editable at runtime via the Permission Matrix (`/admin/permissions`) and Sidebar Access (`/admin/sidebar_accesses`) screens.

## 10. Deployment

- Standard Rails 8 deploy. Set `RAILS_MASTER_KEY` and `DATABASE_URL` in the production environment.
- `bin/rails assets:precompile` (Propshaft) during build.
- `bin/rails db:migrate db:seed` on first deploy.
- A `Dockerfile`/Kamal config can be added; this project was generated with `--skip-docker` to avoid a known generator bug in the local toolchain — regenerate with `bin/rails app:update` or add a Dockerfile manually if containerizing.
- Frontend libraries (Bootstrap, Chart.js, Select2, icons) load from CDN, so no Node build step is required.
