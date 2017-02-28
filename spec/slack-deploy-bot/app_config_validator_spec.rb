describe SlackDeployBot::AppConfigValidator do
  describe 'validates app config' do
    it 'envs should be present' do
      config = {
        path: '/tmp',
        default_branch: :master,
        default_env: :prod,
        deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
      }
      expect{ described_class.validate('my-awesome-app', config) }.to raise_error(
        SlackDeployBot::InvalidAppConfig,
        'app: <my-awesome-app> errors: <envs is missing>'
      )
    end

    it 'path should be present' do
      config = {
        envs: [:staging, :prod],
        default_branch: :master,
        default_env: :prod,
        deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" }
      }
      expect{ described_class.validate('my-awesome-app', config) }.to raise_error(
        SlackDeployBot::InvalidAppConfig,
        'app: <my-awesome-app> errors: <path is missing>'
      )
    end

    it 'deploy_cmd should be present' do
      config = {
        envs: [:staging, :prod],
        path: '/tmp',
        default_branch: :master,
        default_env: :prod,
      }
      expect{ described_class.validate('my-awesome-app', config) }.to raise_error(
        SlackDeployBot::InvalidAppConfig,
        'app: <my-awesome-app> errors: <deploy_cmd is missing>'
      )
    end
  end
end
