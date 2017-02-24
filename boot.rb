require 'config'

Config.setup do |config|
  config.schema do
    required(:deploy_cmd).filled
    required(:envs).filled
    required(:apps).filled
  end
end

Config.load_and_set_settings(Config.setting_files(File.dirname(__FILE__) + '/config', ''))
