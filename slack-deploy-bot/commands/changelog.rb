module SlackDeployBot
  module Commands
    class Changelog < SlackRubyBot::Commands::Base
      match(/changelog (?<app>.+)#(?<branch>.+)$/i) do |client, data, match|
        catch(:exit) do
          app = match[:app]
          SlackDeployBot.check_app_present_in_config(app, client, data)
          branch = match[:branch]
          app_config = SlackDeployBot.apps[app.to_sym]

          git = Utils::Git.new(app_config[:path])
          master_branch = SlackDeployBot::MASTER_BRANCH
          git.fetch_branches                || SlackDeployBot.say_error(client, data, "Cannot fetch repo")
          git.branch_exists?(branch)        || SlackDeployBot.say_error(client, data, "Unknown git branch `#{branch}`")
          git.branch_exists?(master_branch) || SlackDeployBot.say_error(client, data, "Unknown git branch `#{master_branch}`")
          git.sync_branch(branch)           || SlackDeployBot.say_error(client, data, "Couldn't pull `#{branch}`")
          git.sync_branch(master_branch)    || SlackDeployBot.say_error(client, data, "Couldn't pull `#{master_branch}`")

          changelog = git.changelog(branch, against: master_branch).presence || SlackDeployBot::EMPTY_CHANGELOG

          client.say(channel: data.channel, text: "Changelog for `#{branch}`:\n```#{changelog}```")
        end
      end
    end
  end
end
