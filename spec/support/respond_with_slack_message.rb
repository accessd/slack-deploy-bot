require 'rspec/expectations'

RSpec::Matchers.define :message_args do |expected|
  match { |actual| actual[:channel] == expected[:channel] }
  expected[:text] = Array(expected[:text])
  expected[:text].each do |e|
    match { |actual| actual[:text].include?(e) }
  end
end

RSpec::Matchers.define :respond_with_slack_message do |expected|
  match do |actual|
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    allow(Giphy).to receive(:random) if defined?(Giphy)

    if (expected[:message_includes])
      expect(client).to receive(:message).with(message_args(channel: channel, text: expected[:message_includes]))
    end
    if (expected[:messages])
      expected[:messages].each do |msg|
        expect(client).to receive(:message).with(channel: channel, text: msg)
      end
    end
    allow(client).to receive(:message).with(channel: channel, text: instance_of(String))
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    true
  end

  private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    [actual[:channel] || ENV['SLACK_CHANNEL'], actual[:user] || ENV['SLACK_USER_ID'], actual[:message]]
  end
end
