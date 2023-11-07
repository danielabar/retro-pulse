# TODO

- WIP: implement retro-feedback slash command handler to open modal with:
  - select dropdown: keep, stop, try
  - textarea
  - checkbox for anon

- add category enum to Comment model

- Implement interactivity to handle retro-feedback form submission

- experiment: add vscode rest client and try to submit `POST /api/slack/action` (or /command) with/without valid X-Slack-Signature header to see what breaks, where validation happens within slack server gem

- retro-open slash command handler
  - extract logic to a service
  - error handling
  - sanitize `text`

- handle modal form submission for retro-feedback, always save slack user info (check which fields are deprecated)

- Add validation to retrospective model so that only one can be open at a time
- Need action for `/retro-close`

- Why does it show "Sending messages to this app has been turned off" in Slack when clicking on the Retro Pulse app?

- application layout needs work, especially wrt notices (actually, maybe don't need notices anymore)
- build retro view: showing keep, stop, and try feedback as cards in columns
  - if feedback has anon checked, then display anon, otherwise display Slack user
  - nice to have: can we get Slack avatar?
- welcome index view styling, layout

- tests for bot/slash_commands?

## Nice to have

- `/retro-feedback` default category to `keep` should be able to do with `initial_option` in [static_select](https://api.slack.com/reference/block-kit/block-elements#static_select) but getting invalid error
- `/retro-feedback keep` would pre-populate dropdown with `keep` (similar for `stop` and `try`)
- text area form label changes based on dropdown value (eg: What should we keep on doing?), see `views.update` in https://api.slack.com/surfaces/modals
- Can user's edit their feedback?
- oauth scopes are defined in two places: `app_manifest_template.json` and `config/initializers/slack_ruby_bot_server.rb`
- Handle 400 error from `POST /api/teams``, eg: { "type": "other_error", "message": "Team foo is already registered.", "backtrace": "..." } or just display whatever message from this endpoint in welcome view
