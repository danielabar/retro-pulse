# TODO

- WIP: Add slack user id to comment and persist if not anonymous
- WIP: Implement action to handle modal form submission for retro-feedback, always save slack user info (check which fields are deprecated)

- experiment: add vscode rest client and try to submit `POST /api/slack/action` (or /command) with/without valid X-Slack-Signature header to see what breaks, where validation happens within slack server gem

- refactor retro-open slash command handler `bot/slash_commands/retro_open.rb`
  - extract logic to a service: retro creation and construction of response message
  - error handling
  - sanitize `text`

- refactor retro-feedback slash command handler (service, error handling) `bot/slash_commands/retro_feedback.rb`
- refactor view_submission action handler (service, error handling) `bot/actions/view_submission.rb`

- Need action for `/retro-close`

- Why does it show "Sending messages to this app has been turned off" in Slack when clicking on the Retro Pulse app?

- application layout needs work, especially wrt notices (actually, maybe don't need notices anymore)
- build retro view: showing keep, stop, and try feedback as cards in columns
  - if feedback has anon checked, then display anon, otherwise display Slack user
  - nice to have: can we get Slack avatar?
- welcome index view styling, layout

- tests for bot/slash_commands?

- validate/inclusion on all models with enums, error message should include the list of allowed values
- instead of string values everywhere, reference Model.enum...

## Nice to have

- `/retro-feedback` default category to `keep` should be able to do with `initial_option` in [static_select](https://api.slack.com/reference/block-kit/block-elements#static_select) but getting invalid error
- `/retro-feedback keep` would pre-populate dropdown with `keep` (similar for `stop` and `try`)
- text area form label changes based on dropdown value (eg: What should we keep on doing?), see `views.update` in https://api.slack.com/surfaces/modals
- Can user's edit their feedback?
- oauth scopes are defined in two places: `app_manifest_template.json` and `config/initializers/slack_ruby_bot_server.rb`
- Handle 400 error from `POST /api/teams``, eg: { "type": "other_error", "message": "Team foo is already registered.", "backtrace": "..." } or just display whatever message from this endpoint in welcome view
- if user selected not to be anon in their feedback, display their Slack avatar in the feedback card, [users.profile.get](https://api.slack.com/methods/users.profile.get), then given an avatar_hash: `https://avatars.slack-edge.com/YOUR_WORKSPACE/USER_ID/AVATAR_HASH_512.png`, where YOUR_WORKSPACE is your Slack workspace name, USER_ID is the ID of the user whose avatar you want to retrieve, and AVATAR_HASH_512 is the avatar hash followed by _512.png
