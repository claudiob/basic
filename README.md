# Basic

People sign in with their mobile number and a 6-digit code texted to it. 
Admins sign in with Google and read contacts, chats and agents.

## Why it is worth reading

Basic is small on purpose, and still does the things a real app has to get right:

- **Reads and writes go to different database roles, by HTTP verb.** A `GET` runs on a
  connection that logs in as a read-only user with `default_transaction_read_only` on and a
  15-second statement timeout; only `POST`, `PATCH` and `DELETE` reach the writer. A bug in
  a page that only shows things cannot change a row.
- **Admins can ask Claude about the data, safely.** A chat turns a question into one SQL
  `SELECT` through [Omen](https://github.com/claudiob/omen), and runs it as a narrowed role
  that can read the app's tables but not the chats themselves, on the read-only connection.
- **Personal data is encrypted at rest** with Active Record encryption: phone, email and last
  name. The ones that are looked up are encrypted deterministically, so a phone stays
  unique and findable. The admin pages mask them until somebody asks to see one.
- **The forms check themselves in the browser.** The phone field formats a number as it is
  typed, the code is six slots that take digits only, and the submit button waits until
  the form is filled in. The server checks the rules again, a North American number and the
  right code, and a wrong one is refused beside its field.
- **Codes are rate-limited** to five an hour per IP address and five per number, since each
  one costs a text, and they are texted from a background job.
- **The admin is a few lines.** [Recourse](https://github.com/claudiob/recourse) draws every
  admin page, with search, sorting, pagination and dark mode, from the routes and the
  models; a controller says only what is different, such as each admin seeing their own
  chats.

## How to set up locally

- `bundle install`
- Copy `config/credentials/development.key` (ask a teammate for the key if you don't have it)
- `bin/rails db:prepare`
- `bin/rails server`
- Open http://localhost:6289 to sign in with a text, or http://localhost:6289/contacts to sign in with Google.

Outside production a code is not texted: read it from `contacts.pin`.

### Technical requirements

  - PostgreSQL instance running locally or at `DATABASE_URL`
  - Redis instance running locally or at `REDIS_URL`

### Production environment

Production has no Rails credentials: everything is in its config vars.

  - `DATABASE_URL` and `DATABASE_READER_URL`: the database to write to, and the one to read from
  - `DATABASE_SEARCH_PATH`: the schemas tables are looked up in, the first being where Basic keeps
    its own (`public` unless set)
  - `SECRET_KEY_BASE`: to sign sessions and cookies
  - `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`, `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` and
    `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`: to encrypt contacts' phone, email and surname
  - `YT_CLIENT_ID` and `YT_CLIENT_SECRET`: the Google client admins sign in with
  - `ADMIN_DOMAIN`: the Google domain admins sign in from
  - `DEFAULT_URL_HOST`: the host the app answers at
  - `TWILIO_SID` and `TWILIO_SECRET`: the Twilio API key codes are texted with
  - `TWILIO_ACCOUNT_SID`: the Twilio account that API key belongs to
  - `TWILIO_PHONE`: the number codes are texted from
  - `TWILIO_MESSAGING_SID`: the Twilio Messaging Service that number belongs to
  - `ANTHROPIC_API_KEY`: to answer chats
