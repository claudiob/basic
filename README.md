# Basic

People sign in with their mobile number and a 6-digit code texted to it. Admins sign in with
Google and read contacts, chats and agents.

## How to set up locally

- `bundle install`
- Copy `config/credentials/development.key` (ask a teammate for the key if you don't have it)
- `bin/rails db:prepare`
- `bin/rails server`
- Open http://localhost:6289 to sign in with a number, or http://localhost:6289/contacts as
  `admin@example.com`

Outside production a code is not texted: read it from `contacts.pin`.

### Technical requirements

  - PostgreSQL instance running locally or at `DATABASE_URL`
  - Redis instance running locally or at `REDIS_URL`

### Production environment

Deployed to the `basic` app on Heroku. Production has no Rails credentials: everything is in its config vars.

  - `SECRET_KEY_BASE`: to sign sessions and cookies
  - `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`, `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` and
    `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`: to encrypt contacts' phone, email and surname
  - `YT_CLIENT_ID` and `YT_CLIENT_SECRET`: the Google client admins sign in with
  - `ADMIN_DOMAIN`: the Google domain admins sign in from
  - `DEFAULT_URL_HOST`: the host the app answers at
  - `TWILIO_PHONE` and Twilio's API credentials: the number codes are texted from
  - `ANTHROPIC_API_KEY`: to answer chats
