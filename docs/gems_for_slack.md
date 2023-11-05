## Gems for Slack

To make this easier, we will use this gem: [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events)
- this has `teams` endpoints, one of which handles OAuth flow of exchanging a temporary code for actual token
- however, it assumes there's some front end JS that will POST the `code` to the teams endpoint, we will try to do this without any JS
- it also uses GrapeAPI, have to initialize with config.ru

Which in turn depends on:
[slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server)

Which in turn depends on:
[slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client)

## config.ru

Very important file for integrating slack-ruby-bot-server-events
