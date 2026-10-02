# Permissions (main area)

This document describes who may do what in the main area of the application. The
member area below `/mgl` has its own policies, see [member_area.md](member_area.md).

## How a user's access is determined

Access is controlled by two independent things:

1. **Access level**: set by the user's *restricting entity* (see
   [member_area.md](member_area.md#access-levels)).
   - `admin_level?`: no restriction, roles decide.
   - `regional_level?`: restricted to one regional organization. These users can only see
     orchestras and person members of that organization.
   - `member_level?`: orchestra or person member users. `ApplicationController#confine_member_level_user`
     keeps them out of the main area completely.
2. **Roles**: assigned with rolify (`users_roles`).

| Role          | Meaning                                                                 |
|---------------|-------------------------------------------------------------------------|
| `admin`       | everything; implies `national` and `accounting` in all checks below     |
| `national`    | office staff of the national association: member, reference, magazine and festival data |
| `accounting`  | bookings, invoices, SEPA                                                |
| `distinction` | distinctions, honor members, orchestra members                          |
| `festival`    | read access to festival data                                            |
| `magazine`    | magazine issues and advertisers                                         |
| `bulk`        | send bulk mails                                                         |
| `bulk_notify` | view bulk mails                                                         |
| `public_data` | edit and delete public data (URLs, concerts)                            |
| `regional`    | legacy; only still checked in `UserPolicy#show?` and `MagazineSamplingPolicy#show?`. Use the regional access level instead. |

Policies check permissions by name with `permitted?` from the `Permissions` module
(`app/policies/permissions.rb`), which `ApplicationPolicy` and `ApplicationPolicy::Scope`
include. `permitted?(:national, :distinction)` is true if the user has any of the named
permissions. Unknown names raise `ArgumentError`.

| Permission | Granted to |
|------------|------------|
| `:admin`, `:national`, `:accounting`, `:distinction`, `:festival`, `:magazine`, `:bulk`, `:bulk_notify`, `:public_data` | users with that role, and always admins |
| `:regional_role` | users with the legacy `regional` role, and admins |
| `:regional` | regional access level (`User#regional_level?`); not admins |
| `:member` | member access level (`User#member_level?`); not admins |
| `:signed_in` | any user |

The tables below use these names. **national** means admins and users with the `national` role,
**accounting** means admins and users with the `accounting` role, and so on.
`national_permission?` and `accounting_permission?` stay available on policies for views.

Policies declare their rules with `allow` (defined in `ApplicationPolicy`). Each area has a
base policy with its defaults, and concrete policies only add or override actions:

```ruby
class FestivalConcertPolicy < FestivalDataPolicy
  allow :destroy?, to: :national
  allow :programme?, :details?, to: %i[national festival]
end
```

`allow :action?, to: []` denies an action to everybody. Rules that depend on the record,
such as `DistinctionPolicy#update?`, are still written as methods.

| Area | Base policy |
|------|-------------|
| Member data | `MemberDataPolicy` |
| Reference data | `ReferenceDataPolicy` |
| Magazine | `MagazineDataPolicy` |
| Festival data | `FestivalDataPolicy` |
| Public data | `PublicDataPolicy` |

## Enforcement

- Policies live in `app/policies` (Pundit). `ApplicationPolicy` denies every action
  by default, so a policy without methods denies everything, even to admins.
- `AuthenticatedController` and `AuthenticatedNonResourceController` require a signed-in user
  and verify after every action that Pundit was called: `verify_policy_scoped` for `index`,
  `verify_authorized` for all other actions (resource controllers); `verify_authorized`
  for every action (non-resource controllers).
- A denied action raises `Pundit::NotAuthorizedError`. The user is redirected to the root page
  with a flash message.
- Actions without a model use headless policies, for example `authorize :admin, :show?` or
  `authorize :download`.
- Policy scopes restrict lists. `Orchestra.for_user` and `PersonMember.for_user` limit
  regional users to their regional organization. Policies do **not** check the
  regional organization of a single record. Controllers must load single records
  through `policy_scope(...).find`, as `OrchestrasController` and `PersonMembersController` do.
- The main menu (`app/views/application/_main_menu.html.haml`) uses the `User#*_permission?`
  helpers, not the policies:

  | Menu entry      | Helper                         | Who                          |
  |-----------------|--------------------------------|------------------------------|
  | Member data     | `member_data_permission?`      | national, regional, distinction |
  | Reference data  | `reference_data_permission?`   | national                     |
  | Magazine        | `magazine_permission?`         | national, magazine (samplings and address list: national) |
  | Festival        | `festival_permission?`         | national, festival           |
  | Tools           | `tools_permission?`            | accounting                   |
  | Bulk mails      | `bulk_permission?`             | admin, bulk                  |

## Member data

### Defaults (`MemberDataPolicy`)

| Action                          | Who                  |
|---------------------------------|----------------------|
| `index?`                        | national             |
| `show?`                         | national, regional   |
| `create?`, `update?`, `destroy?`| national             |
| scope                           | national: all; others: `nil` |

These policies use the defaults without changes: `MemberPolicy`, `OrchestraContactPolicy`,
`RegionalOrganizationPolicy`, `ContactEventPolicy`. `RegionalOrganizationPolicy` stays member
data because regional users open their own regional organization from the menu.

### Exceptions

| Policy | Action | Who |
|--------|--------|-----|
| `OrchestraPolicy` | `show?` | national, regional, distinction |
| | `invoice_preview?` | accounting |
| | scope | member level: none; national, distinction, regional: `Orchestra.for_user`; others: none |
| `PersonMemberPolicy` | `show?` | national, regional |
| | `create?`, `update?` | national |
| | `invoice_preview?` | accounting |
| | `index?`, `destroy?` | nobody |
| | scope | member level: none; national, regional: `PersonMember.for_user`; others: none |
| `OrchestraMemberPolicy` | `index?`, `show?` | national, distinction (`show?` also regional) |
| | `exchange?` | national |
| | scope | national, distinction |
| `DistinctionPolicy` | `show?`, `create?` | national, distinction |
| | `update?`, `destroy?` | admin; national or distinction only while the distinction has no booking |
| | `invoice_preview?`, `gen_invoice?` | accounting, distinction |
| | scope | national, distinction |
| `HonorMemberPolicy` | `show?` | national, regional, distinction |
| | `create?`, `update?` | national, distinction |
| | scope | national, distinction |
| `ContactEventPolicy` | scope | national |
| `ContactPersonPolicy` | scope | national, festival |
| `MemberEventPolicy` | `download?` | national |
| `ReportSheetPolicy` | `invoice_preview?` | national, accounting |
| | `update_invoice?` | accounting |
| | `copy_from_last_year?` | national |
| `ReportSheetInputPolicy` | `metadata?` | national |
| `DownloadPolicy` (headless) | `index?` | national |
| | `combined_letters_pdf?`, `combined_sepa_pdf?`, `combined_invoice_pdf?`, `combined_sepa?` | accounting |

### Bookings (`MemberAccountBookingPolicy`)

| Action | Who |
|--------|-----|
| `show?` | national |
| `create?` | accounting |
| `update?` | admin: any booking; accounting: manual bookings only (`booking_mode == "M"`) |
| `destroy?` | admin |
| `invoice_preview?`, `invoice_sepa?` | accounting |
| `download?` | national, distinction |
| scope | national, distinction |

Automatic bookings (`booking_mode == "A"`) are created by invoicing and may only be
edited by admins.

## Festival data

### Defaults (`FestivalDataPolicy`)

| Action | Who |
|--------|-----|
| `show?` | national, festival |
| `create?`, `update?` | national |
| `index?`, `destroy?` | nobody |
| scope | national: all; others: raises `Pundit::NotAuthorizedError` |

`FestivalMealPolicy` uses the defaults without changes.

### Exceptions

| Policy | Action | Who |
|--------|--------|-----|
| `FestivalApplicationPolicy` | `destroy?`, `fee_invoice_preview?`, `fee_invoice?`, `ticket_invoice_preview?`, `gen_ticket_invoice?`, `ticket_invoice?`, `no_tickets?`, `no_meals?`, `finalize?`, `storno?`, `gen_participant_sheet?`, `participant_overview?` | national |
| | `stage_plans?`, `datasheets?` | national, festival |
| | scope | national, festival |
| `FestivalConcertPolicy` | `programme?`, `details?` | national, festival |
| | `destroy?` | national |
| | scope | national, festival |
| `FestivalExhibitorPolicy` | `invoice_preview?`, `gen_invoice?`, `storno?` | national |
| | scope | national, festival |
| `FestivalPiecePolicy` | `destroy?` | national |
| | scope | national, festival |
| `EventCardPolicy` | `invoice_preview?`, `storno?`, `pickup?`, `overview?` | national |
| `EventMealPolicy` | `arrival_overview?` | national, festival |
| | scope | national, festival |
| `FestivalMailPolicy` | (inherits `BulkPolicy`) | see below |

## Reference data

### Defaults (`ReferenceDataPolicy`)

| Action | Who |
|--------|-----|
| `index?`, `show?` | signed in |
| `create?`, `update?`, `destroy?` | national |
| scope | signed in: all |

Used by `StatePolicy` and `TariffPolicy`. `RegionalOrganizationBookingPolicy` is still an empty
policy (see [Policies that deny everything](#policies-that-deny-everything)).

## Magazine

### Defaults (`MagazineDataPolicy`)

| Action | Who |
|--------|-----|
| `index?`, `show?`, `create?`, `update?`, `destroy?` | national, magazine |
| scope | national, magazine: all; others: `nil` |

Used by `MagazineIssuePolicy` and `AdvertiserPolicy`. The `magazine` role is created by the
migration `20261002140000_create_magazine_role`.

### Other magazine policies

| Policy | Action | Who |
|--------|--------|-----|
| `MagazineContextPolicy` | `show?`, `create?`, `update?` | national |
| `MagazineSamplingPolicy` | `create?`, `update?` | national |
| | `show?` | national, `regional` role |
| | scope | national |
| `MagazineAdvertPolicy` | everything | nobody (empty policy) |

## Public data

### Defaults (`PublicDataPolicy`)

| Action | Who |
|--------|-----|
| `show?`, `create?` | everyone |
| `update?`, `destroy?` | national, `public_data` role |

Used by `UrlPolicy`, `ConcertPolicy` and `HomepagePolicy`. `HomepagePolicy` limits `update?` and
`destroy?` to admins.

## Administration and tools

| Policy | Action | Who |
|--------|--------|-----|
| `AdminPolicy` (headless) | `index?`, `show?` | admin |
| `UserPolicy` | `show?` | national, `regional` role |
| | `create?` | national |
| | `update?`, `destroy?`, `add_role?` | admin |
| | scope | national |
| `RuntimeOptionPolicy` | `index?`, `create?`, `update?`, `edit?`, `destroy?` | admin |
| | scope | national |
| `BulkPolicy` (headless) | `index?`, `show?` | admin, bulk, bulk_notify |
| | `create?`, `send_mails?` | admin, bulk |
| `CorikaInvoices::InvoicePolicy` | `index?` | national |
| | `destroy?` | admin |
| | scope | national |
| `FeatureRequestPolicy` | `show?`, `create?` | signed in |
| | `update?`, `destroy?` | the author, admin |
| | scope | signed in |

## Policies that deny everything

These policies have no methods, so `ApplicationPolicy` denies every action. Most of their
controllers (public entities such as composers, courses, contests) do not call Pundit at all:

`BoardContactPolicy`, `ClassifiedPolicy`, `CompetitionEntryPolicy`, `ComposerPolicy`,
`ContactPolicy`, `ContestPolicy`, `CoursePolicy`, `DataFilePolicy`, `EnsembleConcertPolicy`,
`EnsemblePolicy`, `FestivalApplicationAttachmentPolicy`, `FestivalPolicy`, `FunctionPolicy`,
`GenericViewPolicy`, `MagazineAdvertPolicy`, `RegionalOrganizationBookingPolicy`, `RolePolicy`,
`UniversityPolicy`, `UploadedFilePolicy`, `UploadPolicy`, `UrlCategoryPolicy`.

## Known inconsistencies

These are known and planned to be cleaned up. Until then, keep them in mind when changing policies.

- Unauthorized scopes behave differently: most return `nil` (the controller then fails
  on the next query method), `FestivalDataPolicy::Scope` raises, and `FeatureRequestPolicy::Scope`
  returns `false`. New scopes should return `scope.none`.
- `show?` does not check the regional organization of a single record (see
  [Enforcement](#enforcement)).
- `PersonMemberPolicy` denies `index?` and `destroy?` to everybody, unlike the other member data.
- `MagazineContextPolicy`, `MagazineSamplingPolicy` and `MagazineAdvertPolicy` don't use the
  magazine defaults yet.
- The `regional` role is still checked in `UserPolicy` and `MagazineSamplingPolicy`.
- The menu helpers on `User` and the policies are two separate sources of truth.
