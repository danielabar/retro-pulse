SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-discuss" do |command|
    handle_retro_discuss_command(command)
  end
end

def handle_retro_discuss_command(command)
  team = Team.find_by(team_id: command[:team_id])
  slack_client = Slack::Web::Client.new(token: team.token)
  channel_id = command[:channel_id]
  command_text = command[:text]
  command.logger.info "=== COMMAND: retro-discuss, Team: #{team.name}, Channel: #{channel_id}, Text: #{command_text}"

  DiscussRetrospective.call(category: command_text, channel_id:, slack_client:)
  nil
end
