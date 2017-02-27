SlackDeployBot.setup do |config|
  config.apps = {
    :'my-awesome-app' => {
      envs: [:staging, :prod],
      path: '~/projects/my-awesome-app',
      default_branch: :master,
      default_env: :prod,
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
    },
    :'my-second-awesome-app' => {
      envs: [:dev, :prod],
      path: '~/projects/my-second-awesome-app',
      deploy_cmd: ->(env, branch) { "BRANCH_NAME=#{branch} bundle exec cap #{env} deploy" }
    }
  }
end
