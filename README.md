# Slack Deploy Bot

Slack bot that helps you deploy your apps.

## What it can do?

For help just type **help**:

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/help-command.png)

Show changelog for your branch against master branch:

    changelog my-awesome-app#feature

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/changelog-command.png)

Deploy your apps to different environments:

    deploy my-awesome-app to prod

or

    deploy my-awesome-app#feature to staging

## Configuration

Copy *config/config.sample.rb* to *config/config.rb*

Example:

```ruby
DeployBot.setup do |config|
  config.apps = {
    :'my-awesome-app' => {
      envs: [:staging, :prod],
      path: '~/projects/my-awesome-app',
      default_branch: :master,
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" } # deploy with Ansible for example
    },
    :'my-second-awesome-app': {
      envs: [:dev, :prod],
      path: '~/projects/my-second-awesome-app',
      deploy_cmd: ->(env, branch) { "BRANCH_NAME=feature bundle exec cap #{env} deploy" } # deploy with Capistrano
    }
  }
end
```

Required options for each app: *envs*, *apps*, *deploy_cmd*

## Development

Start bot with command:

    SLACK_API_TOKEN=xxx bundle exec ruby deploybot.rb

Start console with:

    bundle exec ./console

## Production

Put in root .slack-api-token file which contains api token

Create **config/deploybot.eye** config using **config/deploybot.eye.sample** as sample

If deploybot.eye config was changed than:

    eye l config/deploybot.eye

Restart bot with command:

    eye r config/deploybot

Info for bot process:

    eye i config/deploybot

## TODO

~~1. Configuration (apps, envs, default branch, deploy command)~~
2. Notifications to channel about starting/ending/failing deploy events
3. Specs
