# Slack Deploy Bot

Slack bot that helps you deploy your apps.

## What it can do?

Show changelog for your branch against master branch:

    changelog my-branch

Deploy your apps to different environments:

    deploy my-awesome-app to prod

or

    deploy my-awesome-app#develop to staging

## Development

Start bot with command:

    SLACK_API_TOKEN=xxx BASE_PATH=codebasepath bundle exec ruby deploybot.rb

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
