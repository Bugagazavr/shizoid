class ChatRepository
  def find_or_create_chat(message)
    chat = message.chat
    telegram_id = chat.id

    type =
      case chat.type
      when 'private'
        :personal
      when 'group'
        :faction
      else
        chat.type.to_sym
      end

    Chat.find_or_create_by(telegram_id: telegram_id, chat_type: Chat::CHAT_TYPES.index(type))
  end
end
