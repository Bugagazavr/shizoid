module Bot
  MUTEX = Mutex.new
  THREAD_POOL = Concurrent::FixedThreadPool.new(5)

  class << self
    def redis
      @redis ||= Redis.new(url: configuration.redis_url)
    end

    def logger
      @logger ||= Bot::Logger.new(configuration.debug_level)
    end

    def configuration
      @configuration ||= Bot::Configuration.new
    end

    def start
      Bot.logger.info 'Starting bot'

      Telegram::Bot::Client.run Bot.configuration.telegram_token do |bot|
        bot.options[:timeout] = 1
        bot.listen do |msg|
          Concurrent::Future.execute(executor: THREAD_POOL) do
            begin
              Bot::Message.new(bot, msg).()
            rescue Exception => e
              Bot.logger.error("#{e.inspect}\n#{e.backtrace}")
            end
          end
        end
      end
    end
  end
end
