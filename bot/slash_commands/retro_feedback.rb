SlackRubyBotServer::Events.configure do |config|
  config.on :command, "/retro-feedback" do |command|
    team_id = command[:team_id]
    team = Team.find_by(team_id:)
    slack_client = Slack::Web::Client.new(token: team.token)
    channel_id = command[:channel_id]
    trigger_id = command[:trigger_id]
    command.logger.info "Command: retro-feedback, Team: #{team.name}, Channel: #{channel_id}"

    # https://api.slack.com/methods/views.open
    slack_client.views_open(modal_payload(trigger_id))
    nil
  end
end

# rubocop:disable Metrics/MethodLength
def modal_payload(trigger_id)
  {
    trigger_id:,
    view: {
      type: "modal",
      title: {
        type: "plain_text",
        text: "Retrospective Feedback",
        emoji: true
      },
      submit: {
        type: "plain_text",
        text: "Submit",
        emoji: true
      },
      close: {
        type: "plain_text",
        text: "Cancel",
        emoji: true
      },
      blocks: [
        {
          type: "input",
          block_id: "category_block",
          element: {
            type: "static_select",
            action_id: "category_select",
            placeholder: {
              type: "plain_text",
              text: "Select category"
            },
            options: [
              {
                text: {
                  type: "plain_text",
                  text: "Something we should keep doing"
                },
                value: "keep"
              },
              {
                text: {
                  type: "plain_text",
                  text: "Something we should stop doing"
                },
                value: "stop"
              },
              {
                text: {
                  type: "plain_text",
                  text: "Something to try"
                },
                value: "try"
              }
            ]
          },
          label: {
            type: "plain_text",
            text: "Category"
          }
        },
        {
          type: "input",
          block_id: "comment_block",
          element: {
            type: "plain_text_input",
            action_id: "comment_input",
            multiline: true,
            placeholder: {
              type: "plain_text",
              text: "Enter your feedback"
            }
          },
          label: {
            type: "plain_text",
            text: "Comment"
          }
        },
        {
          type: "input",
          block_id: "anonymous_block",
          optional: true,
          element: {
            type: "checkboxes",
            action_id: "anonymous_checkbox",
            options: [
              {
                text: {
                  type: "plain_text",
                  text: "Yes"
                },
                value: "true"
              }
            ]
          },
          label: {
            type: "plain_text",
            text: "Anonymous"
          }
        }
      ]
    }
  }
end
# rubocop:enable Metrics/MethodLength
