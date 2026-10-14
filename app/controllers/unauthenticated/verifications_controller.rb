# Verifies the phone number a person claimed, via a 6-digit PIN.
class Unauthenticated::VerificationsController < UnauthenticatedController
  before_action :set_contact

  # Displays the verification form.
  def new; end

  # Verifies the PIN and signs the person in.
  def create
    if @contact.update verification_params
      session.delete :verifying_contact_id
      session[:contact_id] = @contact.id
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

private

  def set_contact
    @contact = Contact.find_by id: session[:verifying_contact_id]
    redirect_to new_code_path unless @contact
  end

  def verification_params = params.expect contact: %i[pin_confirmation]
end
