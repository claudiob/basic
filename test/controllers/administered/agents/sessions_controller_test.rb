require 'test_helper'

class Administered::Agents::SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'DELETE /exit signs the admin out, and the next page asks Google again' do
    get new_agent_path(code: 'mock-email')

    delete exit_path

    assert_redirected_to new_agent_url(code: 'mock-email')
    get contacts_path

    assert_redirected_to new_agent_url(code: 'mock-email')
  end
end
