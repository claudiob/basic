# Admins can ask Claude about the data this app holds, one thread per subject.
class Administered::ChatsController < AdministeredController
  # Recourse finds a record by id alone, so another admin's chat is a 404 here instead.
  before_action :set_chat, only: %i[ show destroy ]

  # Opens a chat with the question that prompted it.
  def create
    @chat = Current.agent.chats.create! chat_params
    redirect_to chat_path(@chat), status: :see_other
  end

private

  def recourse_relation = Current.agent.chats

  def set_chat
    @chat = Current.agent.chats.find params.expect(:id)
  end

  def chat_params = params.expect(chat: %i[ question ])
end
