# An abstract controller that sets @chat to one of the admin's own, so another admin's is a 404.
class Administered::Chats::BaseController < AdministeredController
  before_action :set_chat

private

  def set_chat
    @chat = Current.agent.chats.find params.expect(:chat_id)
  end
end
