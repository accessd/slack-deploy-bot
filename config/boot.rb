require 'slack-ruby-bot'

module SlackDeployBot
  class << self
    attr_accessor :apps
  end

  def self.setup
    yield self
  end
end

require_relative 'config'
