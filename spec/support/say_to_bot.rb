def say_to_bot(message:, channel: ENV['SLACK_CHANNEL'], user: ENV['SLACK_USER_ID'])
  client = if respond_to?(:client)
             send(:client)
           else
             SlackRubyBot::Client.new
           end
  message_command = SlackRubyBot::Hooks::Message.new
  allow(Giphy).to receive(:random) if defined?(Giphy)
  allow(client).to receive(:message).with(channel: channel, text: instance_of(String))
  message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
  true
end
