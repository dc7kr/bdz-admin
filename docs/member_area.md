# Member area (`/mgl`)

The member area is a restricted part of the application for **orchestras** and
**person members**. They sign in as `Member`, not as `User`: every orchestra and
person member has exactly one `Member` record (member number, address, account),
and that record is the login. No separate user account is needed. They are trusted
less than office or regional organization users, only see the member area and only
their own data.

Regional organizations do not use the member area. They keep their `User` accounts
with the regional access level in the main area.

## Who signs in where

| Who                                   | Account  | Area        | Sign in                           |
|---------------------------------------|----------|-------------|-----------------------------------|
| office staff, admins                  | `User`   | main area   | `/users/sign_in` (login or email, password or passkey) |
| regional organizations                | `User` with restricting entity `RegionalOrganization` | main area, own organization | `/users/sign_in` |
| orchestras, person members            | `Member` | `/mgl` only | `/mgl/sign_in` (member number, password or passkey) |
| national users impersonating a member | `User`   | `/mgl` in the name of the member | see below |

### Access levels of users

A user's access is limited by its *restricting entity*, stored in
`users.entity_class` / `users.entity_id` and available as the polymorphic
association `User#restricting_entity`. Only regional organizations are allowed.

| Restricting entity     | `User#access_level` | Visible data                                              |
|------------------------|---------------------|-----------------------------------------------------------|
| none                   | `:admin`            | everything the user's roles allow                         |
| `RegionalOrganization` | `:regional`         | orchestras and person members of that regional organization |
| anything else          | `:none`             | nothing, the account can't sign in (see below)            |

Helpers on `User`: `access_level`, `admin_level?`, `regional_level?`,
`restricting_member` (the `Member` record of the entity) and
`restricting_mglnr` / `restricting_mglnr=` (virtual attribute used by the user
admin; setting the member number of a regional organization stores the
organization, an unknown number or the number of an orchestra or person member is
a validation error, a blank value removes the restriction).

`Orchestra.for_user(user)` and `PersonMember.for_user(user)` return the records
visible to a user according to its restricting entity.

Users that were restricted to an orchestra or person member by an earlier version
(`entity_class` `Orchestra` / `PersonMember`) get `access_level` `:none` and
`User#active_for_authentication?` is false. They are told to sign in as a member.

### Assigning a regional user

In the user admin (`/accounts/:id/edit`), enter the member number of the regional
organization in the field **Eingeschränkt auf Mitgl.-Nr.** The user's page shows
the resulting access level and entity.

## Member sign in

`Member` is a devise model next to `User` (devise scope `:member`):

- **Login key**: the member number (`members.mglnr`), which is unique and always
  present. `Member#email` is optional and not unique, so it can't be the login.
- **Modules**: `database_authenticatable`, `recoverable`, `rememberable`,
  `trackable`, `passkey_authenticatable`. Columns: see
  `db/migrate/20261021100000_add_devise_to_members.rb`.
- **Active members only** (`Member#active_for_authentication?`): the member must be
  an `Orchestra` or `PersonMember`, the entity must exist, and the membership must
  not have ended (`austritt_zum` in the past). Soft-deleted members are not found.
- **Passkeys** work as for users, see [passkeys.md](passkeys.md): `Passkey` belongs
  to a polymorphic `owner` (`User` or `Member`), `members.webauthn_id` is the
  WebAuthn user handle.

Routes (`devise_for :members, path: "mgl"`, controllers in `app/controllers/members`):

| Path                                   | Controller#action                      |
|----------------------------------------|----------------------------------------|
| `GET/POST /mgl/sign_in`                | `members/sessions#new/create`          |
| `DELETE /mgl/sign_out`                 | `members/sessions#destroy`             |
| `POST /mgl/sign_in/new_challenge`      | `members/sessions#new_challenge` (passkey login) |
| `/mgl/password/new`, `/mgl/password/edit`, `PATCH /mgl/password` | `members/passwords` |
| `/mgl/passkeys`                        | `members/passkeys` index/create/destroy |

### Passwords

- **Invitation**: staff with the national permission open the entity menu of an
  orchestra or person member and choose **Einladung zum Mitgliederbereich senden**
  (`POST /mgl/invitation`, `Mgl::InvitationsController`, `MemberDataPolicy#invite?`).
  - Members with an email address get the "set your password" mail.
  - Members without one get a one-time link on a page, which the office hands over.
    The link replaces earlier links.
  - Members that have left are refused.
- **Forgot password**: `/mgl/password/new` asks for the member number and mails the
  link to `Member#email`. Members without an email address (about 60 of 700 when
  this was written) get no mail and have to ask the office for an invitation link.
- Links are valid for **7 days** (`reset_password_within` of `Member`), unlike users
  (2 hours).
- Passwords must have the usual devise length. `Member#reset_password` only
  validates the password, so members whose old data is not valid anymore (IBAN,
  address, ...) can still set it.
- Mails are skipped for members without an email address
  (`Member#send_devise_notification`).

### Migration of existing users

- `20261021100000_add_devise_to_members`: devise columns and `webauthn_id` on
  `members`.
- `20261021100100_make_passkeys_polymorphic`: `passkeys.user_id` becomes
  `owner_type` / `owner_id`; the foreign key to `users` is dropped.
- `20261021100200_move_member_level_users_to_members`: for every user restricted to
  an orchestra or person member, the password hash, sign in data and passkeys are
  moved to the Member and the user is deleted. Users with roles and members that
  already have a password are skipped and reported. Skipped users can't sign in as
  user any more (`access_level` `:none`) and need an invitation as member.
- Run it once per database and check the output for skipped users.

## Impersonation by national users

National and admin users (`User#national_permission?` without a restricting
entity) can open the member area in the name of an orchestra or person member, for
example to help a member or to check what it sees. This is the only way a `User`
gets into the member area.

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

## Keeping members in the member area

`ApplicationController#confine_member_level_user` runs for every request of a
signed-in member (and no user at the same time). It allows only:

- controllers below `mgl/`
- devise controllers (sign in, sign out, password)
- `members/passkeys`
- `errors`

Every other request is redirected to `/mgl` (HTML GET) or answered with
`403 Forbidden`.

In addition:

- `after_sign_in_path_for` sends members to `/mgl` after sign in and
  `after_sign_out_path_for` sends them to `/mgl/sign_in`.
- `choose_layout` renders the `mgl` layout for members, so devise and passkey pages
  show the member area menu instead of the admin menu.

Controllers that inherit from `ActionController::Base` directly
(`Public::ApplicationController`, `Ef::ApplicationController`) serve public pages
and are not affected.

## Authentication and authorization

All member area controllers inherit from `Mgl::BaseController`:

- `authenticate_member_or_impersonating_user!`: anonymous requests are sent to
  `/mgl/sign_in`. A national user who is impersonating a member passes without a
  member sign in.
- `require_active_entity`: a member whose orchestra or person member no longer
  exists, for example after soft deletion, is signed out. An impersonation of a
  missing entity ends.
- `mgl_entity` / `current_entity`: the orchestra or person member of the signed in
  member (`current_member.member_entity`) or the impersonated one.
- `mgl_member`: the `Member` record of that entity. It is **not** called
  `current_member`: that is the signed in member of devise, and the two differ
  while impersonating.
- Pundit with namespaced policies:
  - `BaseController` overrides `authorize` and `policy_scope` so they always use
    the policies in `app/policies/mgl`, for example `authorize record` checks
    `Mgl::ReportSheetPolicy`.
  - The Pundit user is a `Mgl::MemberContext` (user, entity, impersonating).
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

All routes work on the signed-in member's own entity. The singular resources carry
no orchestra or person member id.

| Path                                        | Controller#action                  | Notes                                   |
|---------------------------------------------|------------------------------------|-----------------------------------------|
| `GET /mgl`                                  | `mgl/home#show`                    | redirects to orchestra or person member |
| `/mgl/sign_in`, `/mgl/password`, `/mgl/passkeys` | `members/*`                   | sign in, see above                      |
| `POST /mgl/invitation`                      | `mgl/invitations#create`           | staff, see above                        |
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
  type, a dropdown for the member (passkeys, logout) and the turbo confirm dialog.
- Views: `app/views/mgl/**`
- Translations: `config/locales/mgl.de.yml`, `config/locales/mgl.en.yml`
  (`mgl.*`, `users.access_levels.*`, user attribute names),
  `config/locales/mgl_sign_in.{de,en}.yml` (sign in, password, invitation).

## Changes in the main area

- `OrchestraPolicy::Scope` and `PersonMemberPolicy::Scope`:
  - Return `scope.none` instead of `nil` for users without access.
  - Restrict regional users to their regional organization via `for_user`.
- `OrchestraPolicy`, `PersonMemberPolicy`, `MemberDataPolicy` (`show?`),
  `User#member_data_permission?` and the regional entry in the main menu now use
  `regional_level?`. `has_role?(:regional)` only matches global roles, so it never
  recognized users whose `regional` role is tied to a regional organization.

## Files

| File | Purpose |
|------|---------|
| `app/models/member.rb` | devise model of the member area, invitation token |
| `app/models/passkey.rb` | passkeys of users and members (polymorphic owner) |
| `app/models/user.rb` | `restricting_entity` (regional organizations), access levels, `restricting_mglnr` |
| `app/models/orchestra.rb`, `app/models/person_member.rb` | `for_user` scopes |
| `app/models/report_sheet.rb` | `locked?` |
| `app/models/report_sheet_input.rb` | `locked?` delegation |
| `app/controllers/application_controller.rb` | confinement, sign-in redirect, layout |
| `app/controllers/mgl/*.rb` | member area controllers, `invitations_controller.rb` for staff |
| `app/controllers/members/*.rb`, `app/views/members/**` | sign in, password, passkeys, reset mail |
| `app/controllers/concerns/mgl/member_params.rb` | editable member fields |
| `app/policies/mgl/*.rb` | member area policies |
| `app/policies/{orchestra,person_member,member_data}_policy.rb` | regional scoping |
| `app/views/mgl/**`, `app/views/layouts/mgl.html.haml` | views |
| `app/views/users/_form.html.haml`, `show.html.haml`, `app/controllers/users_controller.rb` | assigning the restricting entity (regional organizations) |
| `config/routes.rb` | `namespace :mgl` |
| `config/locales/mgl.{de,en}.yml` | translations |
| `db/migrate/20261002090000_backfill_user_restricting_entities.rb` | backfill of the restricting entity from roles |
| `db/migrate/20261021100*_*.rb` | devise columns for members, polymorphic passkeys, move of member users |

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
