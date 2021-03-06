module Bot
  class Configuration
    attr_reader :telegram_token, :anchors, :root, :bot_name, :dice_roll, :punctuation, :debug_level, :redis_url, :botan_token

    def initialize
      @root = ENV['PWD']
      @options ||= YAML.load(File.open("#{@root}/config/options.yml"))
      @telegram_token = @options['telegram']['token']
      @bot_name = @options['telegram']['name']
      @anchors = @options['anchors']
      @punctuation = @options['punctuation']
      @debug_level = @options['debug_level']
      @redis_url = @options['redis_url']
      @botan_token = @options['botan_token']
    end
  end
end
