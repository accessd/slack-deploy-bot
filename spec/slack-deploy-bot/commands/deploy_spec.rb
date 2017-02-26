describe SlackDeployBot::Commands::Deploy, vcr: { cassette_name: 'rtm_start' } do
  def app
    SlackDeployBot::Bot.instance
  end
  include_context 'connected client'

  before do
    set_slack_user('broskoski')
  end

  it 'executes deploy command' do
    say_to_bot(message: 'deploy-bot deploy my-awesome-app#my-feature to prod')
    expect_deploy_cmd_has_been_executed
  end

  it 'notifies about start and finish deploy' do
    expect(message: 'deploy-bot deploy my-awesome-app#my-feature to prod').
      to respond_with_slack_message(messages: [
        'broskoski started deploying my-awesome-app#my-feature to prod',
        'broskoski finished deploying my-awesome-app#my-feature to prod',
    ])
  end

  describe 'say error' do
    it 'when error happened' do
    expect(message: 'deploy-bot deploy my-second-awesome-app#my-feature to prod').
        to respond_with_slack_message(messages: [":warning: Deploy failed with error: bundler: command not found: cap\n. More info at logs/deploybot.log"])
    end

    it 'in case of unknown app' do
      expect(message: 'deploy-bot deploy unknown-app#my-feature to prod').
        to respond_with_slack_message(messages: [':warning: Invalid app name `unknown-app`, use one of the following: my-awesome-app, my-second-awesome-app'])
    end

    it 'when branch does not exists' do
      expect(message: 'deploy-bot deploy my-awesome-app#unknown-feature to prod').
        to respond_with_slack_message(messages: [':warning: Unknown git branch `unknown-feature`'])
    end
  end

  it 'invalid command' do
    expect(message: 'deploy-bot deploy my-awesome-app#').
      to respond_with_slack_message(messages: ["Sorry <@#{ENV['SLACK_USER_ID']}>, I don't understand that command!"])
  end

  begin 'Helper methods'
    def expect_deploy_cmd_has_been_executed
      file_created_by_deploy_cmd = '/tmp/slack-deploy-bot'
      expect(File.exist?(file_created_by_deploy_cmd)).to eq(true)
      expect(File.stat(file_created_by_deploy_cmd).atime).to be_within(5.second).of Time.now
    end

  end
end
