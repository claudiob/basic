# Admins can log in.
class Unauthenticated::AgentsController < UnauthenticatedController
  # Google redirects here with a GET, and an agent's first login creates them.
  self.writes_on_read = true

  # Only allow admins with Google accounts in this domain.
  ALLOWED_DOMAIN = "@#{ENV.fetch 'ADMIN_DOMAIN', 'gmail.com'}"

  rescue_from(Yt::HTTPError) { |error| refuse error.message }
  before_action :require_code

  # Redirect URI for the Google OAuth flow, which signs in an admin of the allowed domain.
  def new
    if auth.email.ends_with? ALLOWED_DOMAIN
      administrate_as Agent.find_or_create_by!(email: auth.email)
      redirect_to (session.delete(:return_to) || contacts_path), status: :see_other
    else
      refuse "must authenticate from #{ALLOWED_DOMAIN}"
    end
  end

private

  def require_code
    refuse params[:error] unless params[:code] && !params[:error]
  end

  def refuse(error)
    @error = error
    render :new
  end

  def auth
    @auth ||= Yt::Auth.create redirect_uri: new_agent_url, code: params[:code]
  end
end
