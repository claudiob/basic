# CLAUDE.md

Basic is a minimal Rails 8 app. People sign in with their mobile number and a 6-digit code; admins
sign in with Google and read contacts, chats and agents.

## How Basic differs from a standard Rails app

- Rails comes to the `main` branch on GitHub, not a released version
- Background jobs use [ActiveJob::Performs](https://github.com/kaspth/active_job-performs)

## How to work on this codebase

Code however you see fit. At the very end of a task, in one pass, apply STYLE.md and make
`bin/rubocop`, `bin/rake file_length` and `bin/rails test` pass.
