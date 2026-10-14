# Admins can log out.
class Administered::Agents::SessionsController < AdministeredController
  # Logs out an admin.
  def destroy
    session[:agent_id] = nil
    redirect_to google_auth_url, allow_other_host: true
  end
end
