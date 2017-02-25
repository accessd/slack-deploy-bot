$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-deploy-bot'

begin
  SlackDeployBot::Bot.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end
