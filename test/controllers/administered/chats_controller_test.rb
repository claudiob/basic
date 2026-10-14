require 'test_helper'

class Administered::ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    get new_agent_path(code: 'mock-email')
    @chat = omen_readings :chat
    stub_claude claude_answers(note: 'Ask me something.')
  end

  test 'GET /chats/new asks the first question, and POST /chats opens a chat with it' do
    get new_chat_path
    assert_select 'label', text: 'What can I help with?'

    assert_difference -> { agents(:agent).chats.count } do
      post chats_path, params: { chat: { question: 'How many contacts signed in today?' } }
    end
    assert_redirected_to chat_path(Chat.last)
  end

  test 'GET /chats/:id draws the thread, the next question and the button that deletes it' do
    get chat_path(@chat)

    assert_response :success
    assert_select '.chat-bubble', text: 'What can I help with?'
    assert_select '.chat-bubble', text: 'How many contacts are there?'
    assert_select '.chat-bubble', text: 'Two, and each one signed in.'
    assert_select '.chat-bubble.chat-typing'
    assert_select 'label', text: 'Ask a question'
    assert_select 'button', text: 'Delete chat'
  end

  test 'POST /chats/:id/questions asks again within the chat' do
    assert_difference -> { @chat.questions.count } do
      post chat_questions_path(@chat), params: { ask: 'And today?' }
    end

    assert_redirected_to chat_path(@chat)
  end
end
