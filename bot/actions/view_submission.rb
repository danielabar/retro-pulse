SlackRubyBotServer::Events.configure do |config|
  config.on :action, "view_submission" do |action|
    payload = action[:payload]
    team_id = payload["team"]["id"]
    team = Team.find_by(team_id:)
    slack_client = Slack::Web::Client.new(token: team.token)

    # If app is receiving multiple different form submissions, check callback_id and handle accordingly
    callback_id = payload["view"]["callback_id"]
    action.logger.info "=== ACTION: Team: #{team.name}, callback_id: #{callback_id}"

    SaveRetrospectiveFeedback.call(payload:, slack_client:)
    nil
  end
end
