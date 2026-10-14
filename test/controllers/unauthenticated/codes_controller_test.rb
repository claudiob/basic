require 'test_helper'

class Unauthenticated::CodesControllerTest < ActionDispatch::IntegrationTest
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
    assert_equal 'noindex, nofollow, noarchive', response.headers['X-Robots-Tag']
  end
end
