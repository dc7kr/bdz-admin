# Member area (`/mgl`)

The member area is a restricted part of the application for users who belong to a
single **orchestra** or **person member**. These users are trusted less than office
or regional organization users. They only see the member area and only their own
data.

## Access levels

A user's access is limited by its *restricting entity*. The entity is stored in
`users.entity_class` / `users.entity_id` and available as the polymorphic
association `User#restricting_entity`.

| Restricting entity     | `User#access_level` | Area            | Visible data                                                           |
|------------------------|---------------------|-----------------|------------------------------------------------------------------------|
| none                   | `:admin`            | main area       | everything the user's roles allow                                      |
| `RegionalOrganization` | `:regional`         | main area       | orchestras and person members of that regional organization            |
| `Orchestra`            | `:member`           | `/mgl` only     | that orchestra and its contacts, members, report sheets, distinctions, GEMA events and bookings |
| `PersonMember`         | `:member`           | `/mgl` only     | that person member and its bookings                                    |

Helpers on `User`:

- `access_level`: returns `:admin`, `:regional` or `:member`.
- `admin_level?`, `regional_level?`, `member_level?`
- `restricting_member`: the `Member` record of the entity (mglnr, address, account).
- `restricting_mglnr` / `restricting_mglnr=`: virtual attribute used by the user
  admin. Setting a member number looks up the `Member` and stores its
  `member_entity` (regional organization, orchestra or person member). An unknown
  number is a validation error, and a blank value removes the restriction.

`Orchestra.for_user(user)` and `PersonMember.for_user(user)` return the records
visible to a user according to its restricting entity.

### Assigning a user to a member

In the user admin (`/accounts/:id/edit`), enter the member number in the field
**Eingeschränkt auf Mitgl.-Nr.** The user's page shows the resulting access level
and entity.

### Migration of existing users

Before this change, restrictions were only expressed by resource-scoped rolify
roles. The migration `20261002090000_backfill_user_restricting_entities` copies
them into the new columns:

- `regional` role on a `RegionalOrganization` → that regional organization
- `member_manager` role on a `Member` → the member's orchestra or person member

Users that already have an entity keep it. The migration also adds an index on
`users (entity_class, entity_id)`.

## Impersonation by national users

National and admin users (`User#national_permission?` without a restricting
entity) can open the member area in the name of an orchestra or person member, for
example to help a member or to check what it sees.

- Start: **Mitgliederbereich als dieses Mitglied öffnen** in the entity menu of an
  orchestra or person member in the main area (`POST /mgl/impersonation` with
  `entity_type` and `entity_id`). Allowed by `MemberDataPolicy#impersonate?`.
- While impersonating, every member area page shows a warning banner with the
  member and the signed in user, and a **Beenden** button
  (`DELETE /mgl/impersonation`), which returns to the entity in the main area.
- The user stays signed in with its own account. Only the entity is stored in the
  session (`session[:mgl_impersonation]`), so signing out ends the impersonation.
- Inside the member area the user has exactly the rights of the member: the
  `Mgl::` policies get a `Mgl::MemberContext` (user, entity, impersonating) as
  Pundit user instead of the `User`. Changes are saved for the member.
- Start and stop are logged with user id and entity.
- If the impersonated entity no longer exists, the impersonation ends and the user
  is sent back to the main area.

Implementation: `app/controllers/concerns/mgl/impersonation.rb` (included in
`ApplicationController`, provides `mgl_entity`, `mgl_entity_name`,
`impersonating?`), `app/controllers/mgl/impersonations_controller.rb`,
`app/policies/mgl/member_context.rb`.

## Keeping member users in the member area

`ApplicationController#confine_member_level_user` runs for every request of a
signed-in member-level user. It allows only:

- controllers below `mgl/`
- devise controllers (login, logout, profile/password)
- `users/passkeys`
- `errors`

Every other request is redirected to `/mgl` (HTML GET) or answered with
`403 Forbidden`.

In addition:

- `after_sign_in_path_for` sends member-level users to `/mgl` after login.
- `choose_layout` renders the `mgl` layout for member-level users, so devise and
  passkey pages show the member area menu instead of the admin menu.

Controllers that inherit from `ActionController::Base` directly
(`Public::ApplicationController`, `Ef::ApplicationController`) serve public pages
and are not affected.

## Authentication and authorization

All member area controllers inherit from `Mgl::BaseController`:

- `authenticate_user!`: anonymous users are sent to the normal login page
  (`/users/sign_in`, password or passkey). `/mgl/sign_in` redirects there.
- `require_member_level_user`:
  - Users without a member restriction (admins, regional users) are redirected to
    the main area.
  - A member user whose orchestra or person member no longer exists, for example
    after soft deletion, is signed out.
- Pundit with namespaced policies:
  - `BaseController` overrides `authorize` and `policy_scope` so they always use
    the policies in `app/policies/mgl`, for example `authorize record` checks
    `Mgl::ReportSheetPolicy`.
  - `verify_authorized` / `verify_policy_scoped` run after every action.
  - `Pundit::NotAuthorizedError` redirects to `/mgl` with an error flash.

Records are always loaded through `policy_scope`, so ids of other members' records
result in `404 Not Found`.

### Policies (`app/policies/mgl`)

| Policy                         | Scope                              | index | show | create / update / destroy            |
|--------------------------------|------------------------------------|-------|------|--------------------------------------|
| `Mgl::OrchestraPolicy`         | n/a (singular resource)            | n/a   | own  | update own                           |
| `Mgl::PersonMemberPolicy`      | n/a (singular resource)            | n/a   | own  | update own                           |
| `Mgl::OrchestraContactPolicy`  | `orchestra_id` = own orchestra     | orchestra users | own | yes, own                    |
| `Mgl::OrchestraMemberPolicy`   | `orchestra_id` = own orchestra     | orchestra users | own | yes, own                    |
| `Mgl::ReportSheetPolicy`       | `orchestra_id` = own orchestra     | orchestra users | own | update while editable (see below) |
| `Mgl::DistinctionPolicy`       | `orchestra_id` = own orchestra     | orchestra users | own | no (read only)              |
| `Mgl::GemaEventPolicy`         | `orchestra_id` = own orchestra     | orchestra users | own | no (read only)              |
| `Mgl::MemberAccountBookingPolicy` | `member_id` = own member        | member users    | own | no (read only); `download?` when a document exists |

`Mgl::ApplicationPolicy` is the base class and denies everything by default.
`Mgl::OrchestraDataPolicy` is the shared base for records that belong to an
orchestra.

## Routes

All routes work on the signed-in user's own entity. The singular resources carry
no orchestra or person member id.

| Path                                        | Controller#action                  | Notes                                   |
|---------------------------------------------|------------------------------------|-----------------------------------------|
| `GET /mgl`                                  | `mgl/home#show`                    | redirects to orchestra or person member |
| `GET /mgl/sign_in`                          | redirect                           | to `/users/sign_in`                     |
| `POST/DELETE /mgl/impersonation`            | `mgl/impersonations` create/destroy | national users, see above              |
| `/mgl/orchestra`                            | `mgl/orchestras` show/edit/update  | orchestra users                         |
| `/mgl/person_member`                        | `mgl/person_members` show/edit/update | person member users                  |
| `/mgl/orchestra_contacts`                   | `mgl/orchestra_contacts` (no show) | orchestra users                         |
| `/mgl/orchestra_members`                    | `mgl/orchestra_members` (no show)  | orchestra users                         |
| `/mgl/report_sheets`                        | `mgl/report_sheets` index/show/edit/update | orchestra users                 |
| `/mgl/distinctions`                         | `mgl/distinctions` index/show      | orchestra users, read only              |
| `/mgl/gema_events`                          | `mgl/gema_events` index/show       | orchestra users, read only              |
| `/mgl/member_account_bookings`              | `mgl/member_account_bookings` index/show | read only                         |
| `GET /mgl/member_account_bookings/:id/download` | `…#download`                   | invoice PDF / archived document         |
| `/mgl/report_sheet_inputs/*`                | `mgl/report_sheet_inputs`          | token wizard, see below                 |

## Editable data

### Orchestra / person member master data

The entity and its `Member` record are edited in one form and saved in one
transaction. The member fields are submitted as a separate `member` parameter, not
as nested attributes, so a tampered member id can never reach another member
(`Mgl::MemberParams`).

| Record         | Editable by members                                                            |
|----------------|--------------------------------------------------------------------------------|
| `Orchestra`    | `orchName`, `gruendung`, `url`, `publish_url`, `publish_address`               |
| `PersonMember` | `geburtstag`, `telefonDienstl`                                                 |
| `Member`       | `anrede`, `title`, `vorname`, `name`, `strasse`, `plz`, `ort`, `country_code`, `email`, `telefon`, `fax`, `iban`, `bic`, `zahler`, `za` (see below) |

Not editable by members: member number, regional organization, membership dates,
DSGVO fields, magazine count, SEPA mandate data, orchestra type, tariff, remarks.

The payment method (`za`) follows the report sheet input wizard. Members paying by
invoice (`R`) may switch to direct debit (`L`). Members paying by direct debit
cannot switch back.

### Contacts and orchestra members

Orchestra users can list, create, edit and delete their contacts
(`OrchestraContact.permitted_params`) and orchestra members (`first_name`,
`last_name`, `date_of_birth`, `instrument`). New records are always built on the
user's own orchestra, and a submitted `orchestra_id` is ignored.

### Report sheets

A report sheet is editable in the member area only while all of these hold:

1. it belongs to the user's orchestra,
2. it is not invoiced: `ReportSheet#locked?` is false, meaning the `invoiced` flag
   is not set and there is no invoice booking (`booking_type` `B`) for the sheet's
   year, and
3. its year is the current year or later. Older sheets predate invoice bookings in
   this application and are treated as invoiced.

Locked sheets can still be viewed. Opening the edit page of a locked sheet
redirects to the sheet with an explanation.

Members may change the same fields as in the report sheet input wizard:
`uv` (not for coop members), `azubi_*`, `passive`, `supporters`, the ensemble
counts, instrumentation (`zo`, `zi_o`, `go`, `oz`) and `ms_total`. If the orchestra
has an orchestra member list, the age groups (`children`, `teens`, `youth`,
`adult`, `senior`) are recalculated from it on save. Members can't enter them
directly.

Office users still edit report sheets in the main area as before.

### Read-only data

- **Member account bookings**: list with the current balance, booking details, and
  a download of the invoice PDF or archived document if one exists. A missing file
  redirects back with a message.
- **Distinctions**: list and details, with a download of the distinction invoice
  if one exists.
- **GEMA events**: list and details of the orchestra's GEMA events (MongoDB, see
  `GemaEvent`).

There are no write routes for either.

## Report sheet input wizard (token login)

`/mgl/report_sheet_inputs/*` is the existing report sheet wizard that orchestras
open with the token from their report sheet letter. It deliberately does **not**
require a user account, because most orchestras have none. It is authenticated by
token and session instead.

Changes made with the member area:

- The routes are limited to `login`, `submit_login` and the wizard steps. The
  unused `index`, `show`, `new`, `create`, `update` and `destroy` routes were
  removed.
- `ReportSheetInput#locked?` (delegated to `ReportSheet#locked?`) is now defined.
  Step 1 already rendered the "locked" notice through it.
- `submit1`, `submit2`, `submit4`, `upload` and `delete_members` are rejected for
  invoiced report sheets.

## Layout and translations

- Layout: `app/views/layouts/mgl.html.haml`. It has its own menu
  (`app/views/mgl/_main_menu.html.haml`) with entries that depend on the entity
  type, a user dropdown (profile, passkeys, logout) and the turbo confirm dialog.
- Views: `app/views/mgl/**`
- Translations: `config/locales/mgl.de.yml`, `config/locales/mgl.en.yml`
  (`mgl.*`, `users.access_levels.*`, user attribute names).

## Changes in the main area

- `OrchestraPolicy::Scope` and `PersonMemberPolicy::Scope`:
  - Return `scope.none` instead of `nil` for users without access.
  - Return nothing for member-level users.
  - Restrict regional users to their regional organization via `for_user`.
- `OrchestraPolicy`, `PersonMemberPolicy`, `MemberDataPolicy` (`show?`),
  `User#member_data_permission?` and the regional entry in the main menu now use
  `regional_level?`. `has_role?(:regional)` only matches global roles, so it never
  recognized users whose `regional` role is tied to a regional organization.

## Files

| File | Purpose |
|------|---------|
| `app/models/user.rb` | `restricting_entity`, access levels, `restricting_mglnr` |
| `app/models/orchestra.rb`, `app/models/person_member.rb` | `for_user` scopes |
| `app/models/report_sheet.rb` | `locked?` |
| `app/models/report_sheet_input.rb` | `locked?` delegation |
| `app/controllers/application_controller.rb` | confinement, sign-in redirect, layout |
| `app/controllers/mgl/*.rb` | member area controllers |
| `app/controllers/concerns/mgl/member_params.rb` | editable member fields |
| `app/policies/mgl/*.rb` | member area policies |
| `app/policies/{orchestra,person_member,member_data}_policy.rb` | regional scoping |
| `app/views/mgl/**`, `app/views/layouts/mgl.html.haml` | views |
| `app/views/users/_form.html.haml`, `show.html.haml`, `app/controllers/users_controller.rb` | assigning the restricting entity |
| `config/routes.rb` | `namespace :mgl` |
| `config/locales/mgl.{de,en}.yml` | translations |
| `db/migrate/20261002090000_backfill_user_restricting_entities.rb` | backfill from roles |

## Open items

- Leftover files that are no longer used and should be deleted:
  - `app/controllers/mgl/sessions_controller.rb`
  - `app/controllers/mgl/devise_controller.rb`
  - `app/views/mgl/sessions/`
  - `app/views/mgl/orchestras/_entity_menu.html.haml`
  - `app/views/mgl/orchestras/_nav.html.haml`
- There are no automated tests yet. The test database is SQLite and cannot load
  the MySQL schema. The behaviour was verified with an integration script against
  the development database (63 checks covering access, ownership, locking and the
  token wizard).
- The regional scoping only applies to controllers that load records through
  `policy_scope`. Other main-area controllers (reports, bookings, …) still rely on
  role checks only.
