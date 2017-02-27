$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'slack-ruby-bot/rspec'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end

ENV['ENV'] = 'test'

Dir[File.join(File.dirname(__FILE__), 'support', '**/*.rb')].each do |file|
  require file
end

require 'slack-deploy-bot'

SlackDeployBot.setup do |config|
  config.apps = {
    :'my-awesome-app' => {
      envs: [:staging, :prod],
      path: File.join(File.dirname(__FILE__), 'support', 'dummy_app'),
      default_branch: :master,
      default_env: :prod,
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
    },
    :'my-second-awesome-app' => {
      envs: [:dev, :prod],
      path: File.join(File.dirname(__FILE__), 'support', 'dummy_app'),
      deploy_cmd: ->(env, branch) { "BRANCH_NAME=#{branch} bundle exec cap #{env} deploy" }
    },
  }
end

ENV['SLACK_USER_ID'] = 'user'
ENV['SLACK_CHANNEL'] = 'channel'

def slack_users
  {'broskoski' => 'U092V4E9L'}
end

def set_slack_user(user_name)
  ENV['SLACK_USER_ID'] = slack_users[user_name]
end
