require 'test_helper'

class Unauthenticated::VerificationsControllerTest < ActionDispatch::IntegrationTest
  test 'refuses a code that is not the one texted' do
    claim '7773338484'
    get new_verification_url

    assert_select 'p', 'We texted a code to 777-333-8484'
    post verification_url params: { contact: { pin_confirmation: '000000' } }

    assert_response :unprocessable_entity
    assert_select '.otp.is-invalid'
  end

  test 'welcomes whoever answers the code, until they sign out' do
    contact = claim '7773338484'
    # Somebody with a code out is sent to take it back
    get root_url

    assert_redirected_to new_verification_url
    post verification_url params: { contact: { pin_confirmation: contact.pin } }

    assert_redirected_to root_url
    follow_redirect!
    assert_select 'h1', 'You’re in'
    assert_select 'footer button', 'Sign out'
    delete session_url

    assert_redirected_to root_url
    follow_redirect!
    assert_redirected_to new_code_url
  end

private

  # Claims a number, which is what leaves a code waiting to be taken back.
  def claim(phone)
    post code_url params: { contact: { phone: phone } }
    Contact.find_by phone: phone
  end
end
