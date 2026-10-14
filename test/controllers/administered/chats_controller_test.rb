require 'test_helper'

class Administered::ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    get new_agent_path(code: 'mock-email')
    @chat = omen_readings :chat
    stub_claude claude_answers(note: 'Ask me something.')
    @another = Agent.create!(email: 'another@gmail.com').chats.create! question: 'Whose?'
  end

  test 'GET /chats lists the chats this admin opened, and nobody else’s' do
    get chats_path

    assert_response :success
    assert_select 'td a[href=?]', chat_path(@chat)
    assert_select 'td a[href=?]', chat_path(@another), count: 0
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
    assert_select '.chat-bubble', text: 'Example (Swiftly) and Taylor.'
    assert_select '.chat-bubble', text: 'Contacts who signed in: 2.'
    assert_select '.chat-bubble', text: 'Nothing matched that.'
    assert_select '.chat-bubble', text: ThreadHelper::FAILED
    assert_select '.chat-bubble', text: /Eight, and more. That one ran long./
    assert_select '.chat-bubble.chat-typing'
    assert_select 'label', text: 'Ask a question'
    assert_select 'button', text: 'Delete chat'
  end

  test 'GET /chats/:id says sorry where the chat failed before an answer' do
    get chat_path(omen_readings(:failed_chat))

    assert_select '.chat-bubble', text: ThreadHelper::FAILED
  end

  test 'POST /chats/:id/questions asks again within the chat' do
    assert_difference -> { @chat.questions.count } do
      post chat_questions_path(@chat), params: { ask: 'And today?' }
    end

    assert_redirected_to chat_path(@chat)
  end

  test 'GET /chats/:id is not found for another admin’s chat' do
    get chat_path(@another)

    assert_response :not_found
  end

  test 'DELETE /chats/:id deletes the chat and says so' do
    assert_difference -> { Chat.count }, -1 do
      delete chat_path(@chat)
    end

    assert_redirected_to chats_path
    assert_equal 'Chat was deleted.', flash[:notice]
  end
end
