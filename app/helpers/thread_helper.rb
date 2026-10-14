# A chat as the messages bh’s `chat_with` draws.
module ThreadHelper
  # Returns the messages of a chat, oldest first.
  def thread_messages(chat, welcome:)
    turns = chat.turns.flat_map do |asked, said|
      [ Bh::Message.new(side: :right, text: asked), Bh::Message.new(side: :left, text: said) ]
    end
    [ Bh::Message.new(side: :left, text: welcome), *turns ]
  end
end
