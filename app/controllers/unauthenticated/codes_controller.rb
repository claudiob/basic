# People start here, by asking for a code texted to their mobile number.
class Unauthenticated::CodesController < UnauthenticatedController
  # Each code costs a text, so an IP address and a number get five an hour each.
  with_options to: 5, within: 1.hour, only: :create, with: -> { too_many_codes } do
    rate_limit
    rate_limit name: 'phone', by: -> { params.dig(:contact, :phone).to_s.delete '^0-9' }
  end

  # Displays the phone number form.
  def new; end

  # Finds or creates the contact behind the number and texts it a PIN.
  def create
    contact = Contact.find_or_create_by phone: code_params[:phone]

    if contact.persisted?
      contact.generate_pin
      session[:verifying_contact_id] = contact.id
      redirect_to new_verification_path, status: :see_other
    else
      flash.now.alert = contact.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

private

  def code_params = params.expect contact: %i[phone]

  def too_many_codes
    flash.alert = 'Too many codes asked for. Try again in an hour.'
    redirect_to new_code_path, status: :see_other
  end
end
