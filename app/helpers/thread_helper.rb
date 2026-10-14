# A chat as the messages bh’s `chat_with` draws.
module ThreadHelper
  # What an answer that failed on our side says: sorry, and nothing of why.
  FAILED = 'Sorry, I cannot answer that question.'

  # Returns the messages of a chat, oldest first.
  def thread_messages(chat, welcome:)
    said = [thread_message(:left, welcome)]

    chat&.questions&.includes(:answer)&.each do |question|
      answered = thread_answer question.answer, chat.failed?
      said.push thread_message(:right, question.text), answered
    end
    said
  end

private

  def thread_message(side, text = nil) = Bh::Message.new(side:, text:)

  def thread_answer(answer, failed)
    if answer
      thread_message :left, thread_answer_text(answer)
    elsif failed
      thread_message :left, FAILED
    else
      thread_message :left
    end
  end

  def thread_answer_text(answer)
    return FAILED if answer.error.present?

    rows = answer.shown.first 8 if answer.sql.present?
    said = rows ? thread_figures(answer, rows) : answer.note.squish
    said = "#{answer.note.squish.sub(/\.\z/, ':')} #{said}" if rows&.one?
    ran_long = 'That one ran long. Ask for less at a time.' if answer.cut_off?

    [said, ran_long].compact_blank.join ' '
  end

  def thread_figures(answer, rows)
    return 'Nothing matched that.' if rows.empty?

    more = 'more' if answer.shown.size > rows.size || answer.truncated?
    "#{[*rows.map { |row| thread_figure row }, more].compact.to_sentence}."
  end

  def thread_figure(row)
    first, *rest = row.values.compact_blank.map(&:to_s)
    rest.empty? ? first : "#{first} (#{rest.join ', '})"
  end
end
