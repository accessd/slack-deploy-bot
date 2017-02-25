SlackRubyBot.configure do |config|
  config.send_gifs = false
end

module SlackDeployBot
  MASTER_BRANCH = 'master'.freeze
  EMPTY_CHANGELOG = 'none'.freeze
  DEFAULT_BRANCH = MASTER_BRANCH

  def self.app_names
    @@app_names ||= self.apps.keys.map!(&:to_sym)
  end

  def self.check_app_present_in_config(app_name, client, data)
    app_names.include?(app_name.to_sym) || say_error(client, data, "Invalid app name `#{app_name}`, use one of the following: #{app_names.join(', ')}")
  end

  def self.say_error(client, data, text)
    client.say(channel: data.channel, text: ":warning: #{text}")
    throw(:exit)
  end

  class Bot < SlackRubyBot::Bot
    help do
      title 'Deploy Bot'

      desc 'This bot can deploy something to somewhere :)'

      command 'deploy' do
        desc "Command format is: *deploy|накати|задеплой (#{SlackDeployBot.apps.keys.join('|')})#branch_or_tag to|на production*"
      end

      command 'changelog' do
        desc "Shows changelog against #{SlackDeployBot::MASTER_BRANCH}: *changelog (#{SlackDeployBot.apps.keys.join('|')})#branch_or_tag*"
      end
    end
  end
end
