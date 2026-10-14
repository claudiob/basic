require 'test_helper'

class ReaderTest < ActiveSupport::TestCase
  test 'grants the reader role a login and SELECT on every table' do
    told, $stdout = $stdout, StringIO.new
    Reader.grant
    $stdout = told

    assert ApplicationRecord.connection.select_value(<<~SQL)
      SELECT bool_and(has_table_privilege('basic_reader', quote_ident(tablename), 'SELECT'))
        FROM pg_tables WHERE schemaname = 'public'
    SQL
  end
end
