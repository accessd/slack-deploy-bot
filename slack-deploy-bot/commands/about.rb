module SlackDeployBot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      command 'about'
      match(/^(?<bot>[[:alnum:][:punct:]@<>]*)$/u)

      def self.call(client, data, _match)
        client.say(text: SlackDeployBot::ABOUT, channel: data.channel)
      end
    end
  end
end
