# Base class for controllers that require admin access
class AdministeredController < RecoursesController
  # Ahead of recourse's own, whose record lookup reads the admin's relation.
  prepend_before_action :require_administration

private

  def require_administration = restore_administration || request_administration

  def restore_administration
    if current_agent = Agent.find_by(id: session[:agent_id])
      administrate_as current_agent
    end
  end

  def request_administration
    session[:return_to] = request.fullpath
    redirect_to google_auth_url, allow_other_host: true
  end

  def google_auth_url = Yt::Auth.url_for redirect_uri: new_agent_url, scope: []
end
