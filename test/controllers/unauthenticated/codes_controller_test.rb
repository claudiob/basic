require 'test_helper'

class Unauthenticated::CodesControllerTest < ActionDispatch::IntegrationTest
  test 'texts a code to the number claimed, and goes on to take it back' do
    get root_url

    assert_redirected_to new_code_url
    follow_redirect!
    assert_select 'h1', 'Welcome'
    assert_difference 'Contact.count', 1 do
      post code_url params: { contact: { phone: '7773338484' } }
    end

    assert_redirected_to new_verification_url
    contact = Contact.find_by phone: '7773338484'
    assert_match(/\A\d{6}\z/, contact.pin)
    assert_equal "Enter this 6-digit code to proceed: #{contact.pin}\n\n@0.0.0.0 ##{contact.pin}",
                 Twi.mock.messages.sole[:content]
  end

  test 'texts a number five codes an hour and no more' do
    5.times { post code_url params: { contact: { phone: '7773338484' } } }

    assert_no_difference 'Twi.mock.messages.size' do
      post code_url params: { contact: { phone: '7773338484' } }
    end

    assert_redirected_to new_code_url
    assert_equal 'Too many codes asked for. Try again in an hour.', flash[:alert]
  end

  test 'refuses a number the plan has no room for' do
    assert_no_difference 'Contact.count' do
      post code_url params: { contact: { phone: '1234567890' } }
    end

    assert_response :unprocessable_entity
    assert_match 'not a valid phone number', response.body
  end
end
