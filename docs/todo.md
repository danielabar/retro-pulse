# TODO

- WIP: refactor view_submission action handler (service, error handling) `bot/actions/view_submission.rb`. Interactor: ProcessFeedbackSubmission, need tests for interactor!
- revisit interactor `OpenRetrospective`, don't context.fail! when retro save fails. Reserve context.fail! for unexpected errors.

- Need action for `/retro-close` to close the currently open Retrospective

- Need action for `/retro-discuss` to display url of currently open Retrospective
  - Maybe: `/retro-discuss keep` (and try and stop)
  - Or generate column layout in chat.post_message with block kit, [example](https://app.slack.com/block-kit-builder/T1YUEMMQE#%7B%22blocks%22:%5B%7B%22type%22:%22header%22,%22text%22:%7B%22type%22:%22plain_text%22,%22text%22:%22New%20request%22,%22emoji%22:true%7D%7D,%7B%22type%22:%22section%22,%22fields%22:%5B%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Type:*%5CnPaid%20Time%20Off%22%7D,%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Created%20by:*%5Cn%3Cexample.com%7CFred%20Enriquez%3E%22%7D%5D%7D,%7B%22type%22:%22section%22,%22fields%22:%5B%7B%22type%22:%22mrkdwn%22,%22text%22:%22*When:*%5CnAug%2010%20-%20Aug%2013%22%7D,%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Type:*%5CnPaid%20time%20off%22%7D%5D%7D,%7B%22type%22:%22section%22,%22fields%22:%5B%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Hours:*%5Cn16.0%20(2%20days)%22%7D,%7B%22type%22:%22mrkdwn%22,%22text%22:%22*Remaining%20balance:*%5Cn32.0%20hours%20(4%20days)%22%7D%5D%7D,%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22%3Chttps://example.com%7CView%20request%3E%22%7D%7D%5D%7D)

- Why does it show "Sending messages to this app has been turned off" in Slack when clicking on the Retro Pulse app?

- application layout needs work, especially wrt notices (actually, maybe don't need notices anymore)
- build retro view: showing keep, stop, and try feedback as cards in columns
  - retrospectives controller `show` action should `includes` comments
  - if feedback has anon checked, then display anon, otherwise display Slack user
  - nice to have: can we get Slack avatar?
- welcome index view styling, layout
- Generate slack url in WelcomeController rather than in view

- tests for bot/slash_commands?

- validate/inclusion on all models with enums, error message should include the list of allowed values
- instead of string values everywhere, reference Model.enum...

- remove unused routes and pending tests

## Nice to have

- `/retro-feedback` default category to `keep` should be able to do with `initial_option` in [static_select](https://api.slack.com/reference/block-kit/block-elements#static_select) but getting invalid error
- `/retro-feedback keep` would pre-populate dropdown with `keep` (similar for `stop` and `try`)
- text area form label changes based on dropdown value (eg: What should we keep on doing?), see `views.update` in https://api.slack.com/surfaces/modals

- Can user's edit their feedback?
  - Maybe if send block kit response with button, then need to handle new bot action `block_actions`, then check payload: actions action_id: edit-comment-{comment id}
  - But then will need to generate a new modal/form prepopulated with content for user to edit, and when it gets submitted, will come in as `view_submission` and will need to distinguish it from regular feedback form. Can do this by specifying `callback_id` alongside `trigger_id`:
  ```ruby
  slack_client.views_open(modal_payload(trigger_id, 'your_modal_callback_id'))

  def modal_payload(trigger_id, callback_id)
  {
    trigger_id: trigger_id,
    callback_id: callback_id,  # Set the callback_id here
    view: {
      type: "modal",
  ```


- oauth scopes are defined in two places: `app_manifest_template.json` and `config/initializers/slack_ruby_bot_server.rb`
- Handle 400 error from `POST /api/teams``, eg: { "type": "other_error", "message": "Team foo is already registered.", "backtrace": "..." } or just display whatever message from this endpoint in welcome view
- if user selected not to be anon in their feedback, display their Slack avatar in the feedback card, [users.profile.get](https://api.slack.com/methods/users.profile.get), then given an avatar_hash: `https://avatars.slack-edge.com/YOUR_WORKSPACE/USER_ID/AVATAR_HASH_512.png`, where YOUR_WORKSPACE is your Slack workspace name, USER_ID is the ID of the user whose avatar you want to retrieve, and AVATAR_HASH_512 is the avatar hash followed by _512.png

### Edit Feedback

From `bot/actions/view_submission.rb`:

Would need to detect is this new feedback form submission or result of editing?

Would need to send back a response with blockkit so an Edit button can be rendered, something like this:

```ruby
  slack_client.chat_postMessage(
      channel: user_id,
      text: message,
      blocks: [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": message
          }
        },
        # {
        #   "type": "header",
        #   "text": {
        #     "type": "plain_text",
        #     "text": "Your feedback",
        #     "emoji": true
        #   }
        # },
        {
          "type": "divider"
        },
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": new_comment.content
          },
          "accessory": {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Edit",
              "emoji": true
            },
            "value": "edit-comment-#{new_comment.id}",
            "action_id": "edit-comment-#{new_comment.id}"
          }
        }
      ]
    )
```
