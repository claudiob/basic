require 'test_helper'

class Unauthenticated::AgentsControllerTest < ActionDispatch::IntegrationTest
  test 'GET /agent/new signs in an admin of the allowed domain, back where they were' do
    get contacts_path
    get new_agent_path(code: 'mock-email')

    assert_redirected_to contacts_path
  end

  test 'GET /agent/new says why an admin was refused' do
    get new_agent_path(error: 'access_denied')
    assert_select 'p', 'Error: access_denied'

    Yt.configuration.mock_auth_email = 'invalid-email'
    get new_agent_path(code: 'mock-email')
    assert_select 'p', 'Error: Malformed auth code'

    Yt.configuration.mock_auth_email = 'agent@elsewhere.com'
    get new_agent_path(code: 'mock-email')
    assert_select 'p', 'Error: must authenticate from @gmail.com'
  end
end
