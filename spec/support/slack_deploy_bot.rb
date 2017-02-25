RSpec.configure do |config|
  config.before do
    SlackRubyBot.config.user = 'deploy-bot'
  end
end
