# Passkeys

Users can sign in with a passkey (WebAuthn) as well as with username/email and
password. Password login stays available. Passkeys are optional and are added
on top of the password.

Gems: `devise` 5, `devise-passkeys` 0.3, `warden-webauthn` 0.3, `webauthn` 3.4.

## Overview

| Action          | Where                                          | Confirmation                 |
|-----------------|------------------------------------------------|------------------------------|
| Sign in         | Login page, button **Mit Passkey anmelden**    | passkey (browser dialog)     |
| List passkeys   | User menu → **Passkeys** (`/users/passkeys`)   | signed in                    |
| Add a passkey   | `/users/passkeys`, label + current password    | current password + passkey   |
| Delete a passkey| `/users/passkeys`, trash button                | confirmation dialog          |

- Users may delete their last passkey; they can still sign in with their password.
- Member area users (orchestras and person members, see
  [member_area.md](member_area.md)) can manage passkeys too. The page is shown in
  the member area layout.

## Data model

### `passkeys` table

Migration: `db/migrate/20260924074447_create_passkeys.rb`.

| Column         | Type                     | Notes                                                       |
|----------------|--------------------------|-------------------------------------------------------------|
| `user_id`      | reference, FK            |                                                             |
| `label`        | string, not null         | unique per user (`index [user_id, label]`)                  |
| `external_id`  | string, not null, `ascii_bin` | credential id, Base64 (strict). Unique, case-sensitive collation |
| `public_key`   | text, not null           | COSE public key; text because RSA keys exceed 255 chars     |
| `sign_count`   | integer, default 0       |                                                             |
| `last_used_at` | datetime                 | set on every passkey login                                  |
| timestamps     |                          |                                                             |

### `users.webauthn_id`

- String, `ascii_bin`, with a unique index.
- It is the WebAuthn user handle, a random id that is unrelated to `users.id`.
- The migration filled it in for all existing users.
- New users get one in `before_create :generate_webauthn_id`.
- If it is still missing when a passkey is created, `user_details_for_registration`
  sets it then.

### Models

- `Passkey < ApplicationRecord`:
  - `belongs_to :user`
  - validates `label` (present, unique per user), `external_id` and `public_key`
- `User`:
  - `has_many :passkeys, dependent: :destroy`
  - `:passkey_authenticatable` in the `devise` call
  - `self.passkeys_class` and `self.find_for_passkey(passkey)`, both required by
    devise-passkeys

## Configuration

- `config/initializers/devise_passkeys.rb`: registers the devise module
  (`Devise.add_module :passkey_authenticatable, … strategy: true`); the gem doesn't
  do this itself. The user mapping's warden strategies are
  `passkey_authenticatable, rememberable, database_authenticatable`.
- `app/controllers/concerns/webauthn_relying_party.rb`: builds the relying party
  from the current request:
  - `id` is `request.host`
  - `allowed_origins` is `[request.base_url]`
  - `name` is "BDZ Admin"

  Because of this:
  - **A passkey only works on the host name where it was created.** A passkey
    registered on `admin-dev.zupfmusiker.de` does not work on
    `admin.zupfmusiker.de`.
  - **WebAuthn requires HTTPS**, except on `localhost`. Production already runs
    with `assume_ssl`; behind a proxy, `request.base_url` must be the public
    `https://` URL.

## Routes

```ruby
devise_for :users, skip: [ :registrations ], controllers: { sessions: "users/sessions" }

devise_scope :user do
  post "users/sign_in/new_challenge", to: "users/sessions#new_challenge", as: :new_user_session_challenge

  namespace :users do
    resources :passkeys, only: %i[index create destroy] do
      collection do
        post :new_create_challenge
      end
    end
  end
end
```

Self-registration stays disabled (`skip: [:registrations]`). The profile page is
still the hand-wired `devise/registrations#edit` route.

## Flows

### Sign in

1. The login page (`app/views/devise/sessions/new.html.haml`) has a second form
   (Stimulus controller `passkey`). It is only rendered when the mapping supports
   passkeys.
2. **Mit Passkey anmelden** → `POST /users/sign_in/new_challenge`
   (`Users::SessionsController#new_challenge` from the gem). The server stores the
   challenge in the session and returns the request options.
3. The browser calls `navigator.credentials.get`. The signed assertion is written
   to the hidden field `user[passkey_credential]`, and the form is submitted to
   `POST /users/sign_in`.
4. The `passkey_authenticatable` warden strategy:
   - verifies the assertion against the challenge, the stored public key and the
     relying party;
   - looks up the user with `User.find_for_passkey`;
   - sets `last_used_at`.
5. Devise signs the user in as usual. The `after_sign_in_path_for` rules apply, so
   member users land in `/mgl`.

Failures (unknown passkey, failed verification, replayed assertion) render the login
page again (status 200, like a wrong password) with an error from `devise.failure.*`.

### Add a passkey

1. On `/users/passkeys` the user enters a label and their current password
   (Stimulus action `submit->passkey#register`).
2. `POST /users/passkeys/new_create_challenge` with `passkey[label]` and
   `passkey[current_password]`:
   - `verify_current_password`: a wrong password returns `422` with a message.
   - `require_label`: a missing label returns `422`.
   - The gem returns the creation options. Existing passkeys are excluded, and the
     user id is `webauthn_id`.
3. The browser calls `navigator.credentials.create`. The credential JSON is posted
   to `POST /users/passkeys`.
4. `create_passkey` stores the passkey and responds with
   `{ redirect_to: "/users/passkeys" }`. On a validation error (for example a
   duplicate label) it responds with `422` and a message.

The current password replaces the gem's built-in check. That check asks the user to
confirm with an existing passkey before every change, which can't work before the
first passkey exists. For this reason `verify_reauthentication_token` and
`ensure_at_least_one_passkey` are skipped in `Users::PasskeysController`.

### Delete a passkey

`DELETE /users/passkeys/:id` with the Turbo confirm dialog. The gem's concern only
finds passkeys of the current user. The controller redirects with `303 See Other`.

## Front end

`app/javascript/controllers/passkey_controller.js` (Stimulus):

- Targets: `credential`, `label`, `password`, `error`.
- Values: `challengeUrl`, `createUrl`.
- `login` and `register` convert between JSON and the WebAuthn browser API with
  their own base64url encode/decode. Decoding also accepts standard Base64,
  because the gem stores `external_id` that way.
- Sends the CSRF token from the `csrf-token` meta tag in the `X-CSRF-Token` header.
- Ignores `NotAllowedError` / `AbortError` (the user cancelled the browser dialog)
  and shows other errors in the `error` target.
- Hides itself when the browser has no WebAuthn support (`window.PublicKeyCredential`).

## Controllers and views

| File | Purpose |
|------|---------|
| `app/controllers/users/sessions_controller.rb` | `Devise::SessionsController` + `SessionsControllerConcern` (challenge for login) |
| `app/controllers/users/passkeys_controller.rb` | list / add / delete, password check |
| `app/controllers/concerns/webauthn_relying_party.rb` | relying party from the request |
| `app/views/devise/sessions/new.html.haml` | passkey login button |
| `app/views/users/passkeys/index.html.haml` | passkey management |
| `app/views/application/_user_dropdown.html.haml` | **Passkeys** menu entry (main area) |
| `app/views/mgl/_main_menu.html.haml` | **Passkeys** menu entry (member area) |
| `config/locales/passkeys.{de,en}.yml` | texts and WebAuthn error messages |

## Translations

`config/locales/passkeys.{de,en}.yml` contains:

- `account.passkeys`: menu entry
- `activerecord.models.passkey`, `activerecord.attributes.passkey.*`
- `users.passkeys.index.*`: management page
- `devise.sessions.new.sign_in_with_passkey`
- `devise.failure.*`: WebAuthn errors during login, plus
  `credential_missing_or_could_not_be_parsed`, `stored_credential_not_found` and
  `invalid_passkey`
- `devise.passkeys.*`: the same WebAuthn errors plus `passkey_created`,
  `passkey_deleted`, `passkey_label_missing` and `invalid_current_password`

## Tests

`test/integration/passkey_test.rb` uses `WebAuthn::FakeClient` to cover:

- register a passkey (password confirmed), sign out, sign in with it
- a wrong current password gets `422`
- sign in with an unregistered passkey fails

Run them with `bin/rails test test/integration/passkey_test.rb`. The test database is
SQLite and built from the migrations (`RAILS_ENV=test bin/rails db:migrate`). Its schema
is dumped to `db/test_schema.rb` (`schema_dump` in the test section of `config/database.yml`),
so it doesn't overwrite the MySQL `db/schema.rb`.

These flows were also verified with an integration script against the development database:

- password and passkey login
- adding with a wrong or correct password
- `last_used_at` is set on login
- a replayed assertion is rejected
- deleting a passkey

## Known limitations / notes

- `sign_count` is stored on creation but not updated by the gem after a login. This
  is irrelevant for synced passkeys (iCloud, Google, 1Password), which always report
  `0`. Detecting cloned hardware keys would need an update in the strategy.
- Changing the host name of the application makes existing passkeys unusable; users
  have to sign in with their password and register new passkeys.
- `Devise.scoped_views` is enabled. The devise generator left views in
  `app/views/users/{sessions,registrations,passwords,confirmations,unlocks,shared,mailer}`.
  They override the HAML views in `app/views/devise/` and break `/login`
  (`undefined method new_user_registration_path`), so they must be deleted.
