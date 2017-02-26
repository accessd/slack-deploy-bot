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
