require 'dry-validation'

module SlackDeployBot
  class InvalidAppConfig < StandardError; end
  class AppConfigValidator
    AppConfigSchema = Dry::Validation.Schema do
      required(:envs).filled
      required(:path).filled
      required(:deploy_cmd).filled
    end

    def self.validate(app_name, config)
      validation_result = AppConfigSchema.call(config)

      if validation_result.failure?
        errors = validation_result.errors(full: true).values
        raise InvalidAppConfig, "app: <#{app_name}> errors: <#{errors.join(', ')}>"
      end
    end
  end
end
