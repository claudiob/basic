require 'test_helper'

class Administered::ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    get new_agent_path(code: 'mock-email')
    @contact = contacts :contact
  end

  test 'PATCH /contacts/:id updates the names and email, and refuses a new phone' do
    patch contact_path(@contact), params: { contact: { surname: 'Doe', email: '' } }

    assert_equal 'Doe', @contact.reload.surname
    assert_nil @contact.email
    patch contact_path(@contact), params: { contact: { phone: '7773338484' } }

    assert_response :unprocessable_entity
    assert_equal '5556667777', @contact.reload.phone
  end
end
