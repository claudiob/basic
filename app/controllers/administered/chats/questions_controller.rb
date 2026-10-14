# Admins can keep asking within a chat, which is how a clarification is answered.
class Administered::Chats::QuestionsController < Administered::Chats::BaseController
  # Adds a question and sets Claude going again.
  def create
    @chat.ask params.expect(:ask)
    redirect_to chat_path(@chat), status: :see_other
  end
end
