DeployBot.setup do |config|
  config.apps = {
    :'my-awesome-app' => {
      envs: [:staging, :prod],
      path: '~/projects/my-awesome-app',
      default_branch: :master,
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
    },
    :'my-second-awesome-app' => {
      envs: [:dev, :prod],
      path: '~/projects/my-second-awesome-app',
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
    }
  }
end
