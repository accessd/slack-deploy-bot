describe SlackDeployBot::Bot do
  subject { SlackDeployBot::Bot.instance }

  it_behaves_like 'a slack ruby bot'
end
