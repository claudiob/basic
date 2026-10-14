# Admins can ask Claude about the data this app holds, one thread per subject.
class Administered::ChatsController < AdministeredController
  # Opens a chat with the question that prompted it.
  def create
    @chat = recourse_relation.create! chat_params
    redirect_to chat_path(@chat), status: :see_other
  end

private

  def recourse_relation = Current.agent.chats

  def chat_params = params.expect(chat: %i[ question ])
end
