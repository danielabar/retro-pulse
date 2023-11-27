SlackRubyBotServer::Events.configure do |config|
  config.on :action, "view_submission" do |action|
    payload = action[:payload]

    team_id = payload["team"]["id"]
    team = Team.find_by(team_id:)
    slack_client = Slack::Web::Client.new(token: team.token)

    user_id = payload["user"]["id"]
    category = payload["view"]["state"]["values"]["category_block"]["category_select"]["selected_option"]["value"]
    action.logger.info "=== ACTION: view_submission, User: #{payload['user']['username']}, Category: #{category}"

    # TODO: Parse payload to extract feedback comment and category
    # Find the one open retro (should only be one!)

    # Send DM to user confirming we got their feedback
    slack_client.chat_postMessage(
      channel: user_id,
      text: "Thank you, your `#{category}` feedback has been submitted."
    )
    nil
  end
end
