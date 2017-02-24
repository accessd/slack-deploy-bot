# Slack Deploy Bot

Slack bot that helps you deploy your apps.

## What it can do?

For help just type **help**:

Show changelog for your branch against master branch:

    changelog my-awesome-app#feature

Deploy your apps to different environments:

    deploy my-awesome-app to prod

or

    deploy my-awesome-app#feature to staging

## Configuration

Copy *config/settings.sample.yml* to *config/settings.yml* for production or to *config/settings.local.yml* for
development.

Example:

```yaml
envs:
  - staging
  - prod
apps:
  my-awesome-app: '~/projects/my-awesome-app' # app name with path to it
default_branch: master # default branch to deploy, is not required
deploy_cmd: ./deploy.sh
```

Required options: envs, apps, deploy_cmd

## Development

Start bot with command:

    SLACK_API_TOKEN=xxx bundle exec ruby deploybot.rb

Start console with:

    bundle exec ./console

## Production

Put in root .slack-api-token file which contains api token

Create **deploybot.eye** config using **deploybot.eye.sample** as sample

If deploybot.eye config was changed than:

    eye l deploybot.eye

Restart bot with command:

    eye r deploybot

Info for bot process:

    eye i deploybot

## TODO

1. Configuration (apps, envs, default branch, deploy command)
2. Notification to some general channel about starting/ending/failing deploy events
3. Specs
