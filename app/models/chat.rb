class Chat < ActiveRecord::Base
  CHAT_TYPES = %i[personal faction supergroup channel].freeze

  has_many :pairs

  after_commit :log_creation, on: :create
  before_save :log_new_gab, if: :random_chance_changed?

  def migrate_to_chat_id(new_id)
    Bot.logger.info "[chat #{chat_type_name} #{telegram_id}] Migrating ID to #{new_id}"
    self.telegram_id = new_id
    save
  end

  def chat_type_name
    CHAT_TYPES[chat_type]
  end

  private

  def log_new_gab
    Bot.logger.info "[chat #{chat_type_name} #{telegram_id}] New gab level is set to #{random_chance}"
  end

  def log_creation
    Bot.logger.info "[chat #{chat_type_name} #{telegram_id}] Created with internal ID #{id}"
  end
end
