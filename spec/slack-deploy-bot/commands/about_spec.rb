describe SlackDeployBot::Commands::Default do
  def app
    SlackDeployBot::Bot.instance
  end

  it 'deploy-bot' do
    expect(message: 'deploy-bot').to respond_with_slack_message(messages: [SlackDeployBot::ABOUT])
  end
end
