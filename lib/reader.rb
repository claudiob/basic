# Creates the Postgres role that read-only requests log in as, and grants it SELECT.
module Reader
  # The role name the 'reader' entry in config/database.yml connects as.
  ROLE = 'basic_reader'

  # Grants on every database this environment prepares.
  def self.grant = Omen.each_database { |connection| grant_on connection }

  # Grants on the database a writing connection is connected to.
  def self.grant_on(connection)
    statements(connection).each { |statement| Omen.attempted connection, statement }
    held = Omen::Attributes.dangerous connection, ROLE
    warn "#{ROLE} holds #{held.to_sentence}, so ask for it to be taken away" if held.any?
    puts "Granted SELECT on #{connection.current_database} to #{ROLE}"
  end

  # The password the role logs in with: the environment's, or 'reader' in development and test.
  def self.password = ENV['BASIC_READER_PASSWORD'] || ('reader' if Rails.env.local?)

  # The statements that create the role and grant it SELECT, in order.
  def self.statements(connection)
    role = connection.quote_table_name ROLE
    database = connection.quote_table_name connection.current_database
    made = Omen::Grants.made connection, ROLE, login: true
    made << "ALTER ROLE #{role} WITH PASSWORD #{connection.quote password}" if password
    made + [
      "GRANT CONNECT ON DATABASE #{database} TO #{role}",
      "GRANT USAGE ON SCHEMA public TO #{role}",
      "GRANT SELECT ON ALL TABLES IN SCHEMA public TO #{role}",
      "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO #{role}",
    ]
  end
end
