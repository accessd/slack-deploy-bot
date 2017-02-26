describe SlackDeployBot::Commands::Changelog do
  def app
    SlackDeployBot::Bot.instance
  end

  it 'shows changelog for branch' do
    expect(message: 'deploy-bot changelog my-awesome-app#my-feature').
      to respond_with_slack_message(message_includes: ['Changelog for `my-feature`', 'add deploy.sh (Accessd)'])
  end

  describe 'say error' do
    it 'in case of unknown app' do
      expect(message: 'deploy-bot changelog unknown-app#my-feature').
        to respond_with_slack_message(messages: [':warning: Invalid app name `unknown-app`, use one of the following: my-awesome-app, my-second-awesome-app'])
    end

    it 'when branch does not exists' do
      expect(message: 'deploy-bot changelog my-awesome-app#unknown-feature').
        to respond_with_slack_message(messages: [':warning: Unknown git branch `unknown-feature`'])
    end
  end

  it 'invalid command' do
    expect(message: 'deploy-bot changelog my-awesome-app#').to respond_with_slack_message(messages: ["Sorry <@user>, I don't understand that command!"])
  end
end
