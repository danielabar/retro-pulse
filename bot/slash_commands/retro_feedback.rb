SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-feedback" do |command|
    team_id = command[:team_id]
    team = Team.find_by(team_id:)
    slack_client = Slack::Web::Client.new(token: team.token)
    channel_id = command[:channel_id]
    trigger_id = command[:trigger_id]
    command.logger.info "=== COMMAND: retro-feedback, Team: #{team.name}, Channel: #{channel_id}"

    InitiateFeedbackForm.call(trigger_id:, slack_client:)
    nil
  end
end
