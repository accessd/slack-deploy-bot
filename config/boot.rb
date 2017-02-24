require 'slack-ruby-bot'
require_relative '../helpers'

module DeployBot
  class << self
    attr_accessor :apps
  end

  def self.setup
    yield self
  end
end

require_relative 'config'
