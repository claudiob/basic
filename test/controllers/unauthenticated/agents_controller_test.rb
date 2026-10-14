require 'test_helper'

class Unauthenticated::AgentsControllerTest < ActionDispatch::IntegrationTest
  test 'GET /agent/new says why an admin was refused' do
    get new_agent_path(error: 'access_denied')
    assert_select 'p', 'Error: access_denied'

    Yt.configuration.mock_auth_email = 'invalid-email'
    get new_agent_path(code: 'mock-email')
    assert_select 'p', 'Error: Malformed auth code'

    Yt.configuration.mock_auth_email = 'admin@example.org'
    get new_agent_path(code: 'mock-email')
    assert_select 'p', 'Error: must authenticate from @example.com'
  end
end
