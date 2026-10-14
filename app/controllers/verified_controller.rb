# Base class for controllers a person reaches once their number is verified.
class VerifiedController < ApplicationController
  before_action :set_contact

private

  def set_contact
    @contact = Contact.find_by id: session[:contact_id]
    redirect_to way_in_path unless @contact
  end

  def way_in_path
    Contact.exists?(id: session[:verifying_contact_id]) ? new_verification_path : new_code_path
  end
end
