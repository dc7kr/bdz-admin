# Runtime options

Application settings that admins change in the web UI without a restart or deployment
(user menu > Admin > Laufzeitoptionen, `/runtime_options`).

```ruby
RuntimeOption.festival_year             # => 2026
RuntimeOption[:festival_application_open]
```

## Options

| Key | Type | Used for |
|-----|------|----------|
| `festival_year` | integer | current eurofestival: `current_festival` scopes, new applications, tickets, meals, mails |
| `festival_application_open` | boolean | public festival application (`Ef::FestivalApplicationsController#new`) |
| `presale_active` | boolean | public ticket order form |
| `pickup_date` | datetime | pickup date in ticket and participant invoice mails |
| `festival_email` | string | sender of `FestivalMail` |

An option without a database row uses its default. For now the defaults come from the
`config` section of `config/bdz-settings.yml`, so nothing changes until an admin saves a
value. "Standard" in the UI deletes the row and returns to the default.

## Caching

Reading an option doesn't query the database. Each process (puma, sidekiq, console)
keeps all values in memory:

- The cache is loaded on the first read.
- The process that saves or resets an option reloads right away (`after_commit`).
- Every other process checks for changes at most every `check_interval` seconds with a
  single `SELECT COUNT(*), MAX(updated_at) FROM runtime_options` and reloads when the
  result differs. So a change reaches all web and sidekiq processes within that interval.
- "Alle Prozesse neu laden" (`RuntimeOption.reload_all!`) touches all rows, so every
  process reloads at its next check. This is only needed after rows were changed by SQL
  without updating `updated_at`.
- If the table is missing (e.g. migration pending), the defaults are used and loading is
  retried at the next check.

The interval defaults to 10 seconds and is set with
`config.x.runtime_options.check_interval`. The test environment uses 0, so every read
checks and tests see their own changes and the rollback afterwards.

## Adding an option

1. Define it in `app/models/runtime_option.rb`:

   ```ruby
   option :ticket_shop_url, :string, default: "https://..."
   ```

   Types are `string`, `integer`, `boolean` and `datetime`. The default may be a value or
   a lambda. Defaults are cast to the type, `nil` booleans become `false`.
2. Add `name` and `hint` under `runtime_option.options.<key>` in
   `config/locales/runtime_options.{de,en}.yml`.

The option then appears in the UI and is readable as `RuntimeOption.<key>`.

## Permissions

Only admins see and change runtime options (`RuntimeOptionPolicy`).
