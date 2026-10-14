#!/bin/bash
# .aircon/aircon_init.sh
#
# This script runs inside the container after aircon completes its setup.
# It is invoked as a login shell (bash -l), so environment variables
# configured by aircon are available:
#
#   GH_TOKEN / GITHUB_PERSONAL_ACCESS_TOKEN  — GitHub personal access token
#   CLAUDE_CODE_OAUTH_TOKEN                  — Claude Code OAuth token
#   PATH                                     — includes ~/.local/bin (claude, gh, etc.)
#
# The working directory is the repository root inside the container.
#
# Examples:
#   npm install
#   bundle install
#   cp .env.example .env

set -e

echo "Waiting for database to be ready..."
# Try `bin/rails db:version` until it succeeds or we hit a timeout.
# This works for most adapters (Postgres/MySQL) where the command
# will fail if the DB server is not reachable.
MAX_ATTEMPTS=30
SLEEP_SECONDS=2
attempt=0
until pg_isready --quiet; do
	attempt=$((attempt+1))
	if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
		echo "Timed out waiting for database after ${MAX_ATTEMPTS} attempts."
		echo "You can re-run 'bin/rails db:prepare' once the DB is available."
		exit 1
	fi
	echo "Database not ready (attempt ${attempt}/${MAX_ATTEMPTS}). Sleeping ${SLEEP_SECONDS}s..."
	sleep "$SLEEP_SECONDS"
done

echo "Database is available — running db:prepare"
bin/rails db:prepare

echo "Database setup complete!"

mkdir -p .claude
ruby -rjson -e '
  path = ".claude/settings.local.json"
  settings = begin
    File.exist?(path) ? JSON.parse(File.read(path)) : {}
  rescue JSON::ParserError
    {}
  end
  settings["permissions"] ||= {}
  settings["permissions"]["defaultMode"] = "bypassPermissions"
  settings["skipDangerousModePermissionPrompt"] = true
  File.write(path, JSON.pretty_generate(settings) + "\n")
'
echo "Claude Code bypass-permissions mode enabled"

exec "$@"
