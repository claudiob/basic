# A person can sign out.
class Verified::SessionsController < VerifiedController
  # Signs out, back to where the flow begins.
  def destroy
    session.delete :contact_id
    redirect_to root_path, status: :see_other
  end
end
