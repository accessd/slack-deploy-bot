# Slack Deploy Bot

[![Build Status](https://travis-ci.org/accessd/slack-deploy-bot.svg?branch=master)](https://travis-ci.org/accessd/slack-deploy-bot)

Slack bot that helps you to deploy your apps.

## What it can do?

For help just type **help**:

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/help-command.png)


Show **changelog** for your branch against *master* branch:

    changelog my-awesome-app#feature

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/changelog-command.png)


**Deploy** your apps to different environments:

    deploy my-awesome-app to prod

or specific branch:

    deploy my-awesome-app#feature to staging

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/deploy-command.png)


in case of deploy fail you'll see the error message:

![ScreenShot](https://raw.github.com/accessd/slack-deploy-bot/master/images/deploy-failed.png)

## Configuration

Copy *config/config.sample.rb* to *config/config.rb*

Example:

```ruby
DeployBot.setup do |config|
  config.apps = {
    :'my-awesome-app' => {
      envs: [:staging, :prod],
      path: '~/projects/my-awesome-app',
      default_branch: :master, # default branch to deploy
      deploy_cmd: ->(env, branch) { "./deploy.sh #{env} #{branch}" } # deploy with Ansible for example
    },
    :'my-second-awesome-app': {
      envs: [:dev, :prod],
      path: '~/projects/my-second-awesome-app',
      deploy_cmd: ->(env, branch) { "BRANCH_NAME=#{branch} bundle exec cap #{env} deploy" } # deploy with Capistrano
    }
  }
end
```

Required options for each app: *envs*, *path*, *deploy_cmd*

## Development && Testing

Start bot with command:

    SLACK_API_TOKEN=xxx foreman start

Start console with:

    bundle exec ./console

Run specs with:

    bundle exec rake

Before starting specs please run:

    git submodule update --init

for fetching *spec/support/dummy_app*

## Production

### How to setup

1. Clone the repo
2. `cp ./config/config.sample.rb ./config/config.rb`
3. Edit `./config/config.rb` and add configuration for your app
4. `bundle install --without development test`
5. You can try to launch bot with `SLACK_API_TOKEN=xxx bundle exec ruby run.rb` and test it
6. Launch bot as a daemon (you can use *eye, upstart, systemd*, etc.)

I'd recommend to use **eye** gem for launching bot. But it's up to you.

### Launching with eye

Please follow instruction on [[https://github.com/kostya/eye]] for installing **eye**

Put in the root *.slack-api-token* file which contains api token

Create **config/slack-deploy-bot.eye** config using **config/slack-deploy-bot.eye.sample** as sample

Start bot:

    eye s config/slack-deploy-bot.eye

If slack-deploy-bot.eye config was changed than:

    eye l config/slack-deploy-bot.eye

Restart bot with command:

    eye r config/slack-deploy-bot.eye

Info about bot process:

    eye i config/slack-deploy-bot.eye

## TODO

1. ~~Configuration (apps, envs, default branch, deploy command)~~
2. ~~Notifications to channel about starting/ending/failing deploy events~~
3. ~~Specs~~
