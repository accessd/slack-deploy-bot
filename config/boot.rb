require 'slack-ruby-bot'

module SlackDeployBot
  class << self
    attr_accessor :apps
  end

  def self.setup
    yield self
  end
end

SlackDeployBot.apps = {}

unless ENV['ENV'] == 'test'
  require_relative 'config'
end

SlackDeployBot.apps.each do |app_name, app_config|
  SlackDeployBot::AppConfigValidator.validate(app_name, app_config)
end
