# Retro Pulse

This is a companion project for a blog post about building Slack Apps with Rails 7.

This Slack app, built with Rails 7, is designed to streamline the [agile retrospective](https://www.scrum.org/resources/what-is-a-sprint-retrospective) process with Slack slash commands. While traditional retrospectives are often scheduled at the end of a sprint, shape up cycle, or project, Retro Pulse recognizes the need for a more fluid feedback mechanism. With Retro Pulse, team members can easily submit feedback as it arises during project development, ensuring that valuable insights are captured and not lost in the shuffle.

**NOTE:** Retro Pulse is tailored for simplicity. This app is designed for individual teams to integrate into their workspace, with the intention that the underlying Rails app is kept secure behind a VPN or other access controls (i.e. not publicly accessible). The initial focus is on delivering a straightforward solution, so a full SAAS/multi-tenant architecture is not part of the initial release.

## Setup

Make sure you're on Ruby version as specified in `.ruby-version`.

Make sure you have [Docker](https://docs.docker.com/engine/install/) installed for your OS (this project runs Postgres in a Docker container).

Create a [free account with Ngrok](https://ngrok.com/)

Create a new Slack App at [Your Apps](https://api.slack.com/apps). For now, choose "From Scratch" name: `retro-pulse` and select your workspace. We'll be uploading a manifest with the full definition later.

Install dependencies:

```
bin/setup
```

## Development

Start ngrok and make a note of the forwarding url it generates.

```
ngrok http 3000
```

Example: https://abcd-123-123-123-123.ngrok-free.app

**NOTE:** On the ngrok free plan, it will generate a different forwarding url each time you start it.

Populate env vars:
```bash
cp .env.template .env
# fill in SERVER_HOST from ngrok, eg: abcd-123-123-123-123.ngrok-free.app
# fill in other values from your Slack app
```

Start database:

```
docker-compose up
```

Replant seeds:
```
bin/rails db:seed:replant
```
**WATCH OUT:** This also wipes out `teams` table used by `slack-ruby-bot-server-events` to keep track of what Slack teams have OAuthed the Slack application. But you can always OAuth again by clicking "Add to Slack" from the index page.

Run the TailwindCSS build and a local Rails server:

```
bin/dev
```

Update URLs in your Slack app settings based on the forwarding address assigned by ngrok:

```
bundle exec rake manifest:generate
```

Copy the generated `app_manifest.json` and paste it in the App Manifest section of the Slack App you created earlier. If you see a message about Event Subscription url being unverified, "click here" to have Slack verify it. This should work given that the Rails server is running and ngrok is forwarding to it.

Run tests:

```ruby
bin/rspec
```

### Debugging

If want to place `debugger` in Ruby code, need to start server with `bin/rails s` instead of `bin/dev`.

## TODO

- Add validation to retrospective model so that only one can be open at a time
- retro-open slash command handler
  - extract logic to a service
  - error handling
  - sanitize `text`
- implement retro-keep slash command handler to open modal with textarea and checkbox for anon
- handle modal form submission for retro-keep, always save slack user info (check which fields are deprecated)
- implement retro-stop
- implement retro-try
- build retro view showing keep, stop, and try feedback as cards in columns
  - if feedback has anon checked, then display anon, otherwise display Slack user
  - nice to have: can we get Slack avatar?
- application layout needs work, especially wrt notices (actually, maybe don't need notices anymore)
- welcome index view styling, layout
- tests for bot/slash_commands?
- oauth scopes are defined in two places: `app_manifest_template.json` and `config/initializers/slack_ruby_bot_server.rb`
- Handle 400 error from POST /api/teams, eg: { "type": "other_error", "message": "Team foo is already registered.", "backtrace": "..." }

## Further Reading

- [Gems for Slack](docs/gems_for_slack.md)
- [Grape Routes](docs/grape_routes.md)
- [OAuth](docs/oauth.md)
- [Scaffolding](docs/scaffolding.md)
- [Visual Design](docs/visual_design.md)
