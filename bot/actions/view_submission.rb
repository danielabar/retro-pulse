# rubocop:disable Metrics/BlockLength
SlackRubyBotServer::Events.configure do |config|
  config.on :action, "view_submission" do |action|
    payload = action[:payload]

    team_id = payload["team"]["id"]
    team = Team.find_by(team_id:)
    slack_client = Slack::Web::Client.new(token: team.token)

    # Parse payload to extract comment, category, anonymous, slack user id and slack username
    user_id = payload["user"]["id"]
    category = payload["view"]["state"]["values"]["category_block"]["category_select"]["selected_option"]["value"]
    comment = payload["view"]["state"]["values"]["comment_block"]["comment_input"]["value"]
    anonymous = payload["view"]["state"]["values"]["anonymous_block"]["anonymous_checkbox"]["selected_options"].present?
    slack_user_id = payload["user"]["id"]
    slack_username = payload["user"]["username"]
    action.logger.info "=== ACTION: User: #{payload['user']['username']}, Cat: #{category}, Anon: #{anonymous}"

    # Find the one open Retrospective model (should only be one!)
    retrospective = Retrospective.find_by(status: "open")

    # Only save slack info when anonymous is true.
    slack_info = anonymous ? { slack_user_id: nil, slack_username: nil } : { slack_user_id:, slack_username: }

    # Save the new Comment for the Retrospective
    new_comment = Comment.new(
      content: comment,
      anonymous:,
      category:,
      retrospective:,
      **slack_info
    )
    message = if new_comment.save
                "Thank you, your `#{category}` feedback has been submitted."
              else
                "Could not save your `#{category}` feedback due to: #{new_comment.errors.full_messages}"
              end

    # Send DM to user confirming we got their feedback
    slack_client.chat_postMessage(
      channel: user_id,
      text: message
    )
    nil
  end
end
# rubocop:enable Metrics/BlockLength
