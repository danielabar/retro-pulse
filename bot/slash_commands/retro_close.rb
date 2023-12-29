SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-close" do |command|
    handle_retro_close_command(command)
  end
end

def handle_retro_close_command(command)
  team = Team.find_by(team_id: command[:team_id])
  slack_client = Slack::Web::Client.new(token: team.token)
  channel_id = command[:channel_id]
  command.logger.info "=== COMMAND: retro-close, Team: #{team.name}, Channel: #{channel_id}"

  CloseRetrospective.call(channel_id:, slack_client:)
  nil
end
