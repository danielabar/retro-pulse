SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-open" do |command|
    handle_retro_open_command(command)
  end
end

def handle_retro_open_command(command)
  team = Team.find_by(team_id: command[:team_id])
  slack_client = Slack::Web::Client.new(token: team.token)
  channel_id = command[:channel_id]
  command_text = command[:text]
  command.logger.info "=== COMMAND: retro-open, Team: #{team.name}, Channel: #{channel_id}, Title: #{command_text}"

  OpenRetrospective.call(title: command_text, channel_id:, slack_client:)
  nil
end
