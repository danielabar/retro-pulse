SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-open" do |command|
    team_id = command[:team_id]
    team = Team.find_by(team_id:)
    # needed because we want to respond back with a message like "retro created, maybe even with the url"
    slack_client = Slack::Web::Client.new(token: team.token)
    channel_id = command[:channel_id]
    # this is the title (sanitize for a real app)
    text = command[:text].strip
    command.logger.info "Received team: #{team.name}, channel_id: #{channel_id}, text: #{text}"

    # Create a retro and reply back in Slack, ref: https://api.slack.com/methods/chat.postMessage
    retrospective = Retrospective.new(title: text)
    if retrospective.save
      url = Rails.application.routes.url_helpers.retrospective_url(
        retrospective, host: ENV.fetch("SERVER_HOST_NAME"), protocol: "https"
      )
      slack_client.chat_postMessage(
        channel: channel_id,
        text: "Created retro #{text}, view it at #{url}"
      )
    else
      slack_client.chat_postMessage(
        channel: channel_id,
        text: "Could not create retro #{text}, error: #{retrospective.errors.full_messages}"
      )
    end
    nil
  end
end
