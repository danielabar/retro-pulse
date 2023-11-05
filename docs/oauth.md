# Slack OAuth

Rails app makes GET request to Slack like this:
```htm
<a href="https://slack.com/oauth/v2/authorize?scope=commands&amp;client_id=123456">
  Add to Slack
</a>
```

Ends up at Slack something like this:
```
https://testbotdevgroup.slack.com/oauth?
  client_id=123456&
  scope=commands&
  user_scope=&
  redirect_uri=&
  state=&
  granular_bot_scope=1&
  single_channel=0&
  install_redirect=&
  tracked=1
  &team=
```
![Slack asking for permission](docs/slack-asking-for-permission.png)

Should redirect back to wherever you configured Slack OAuth in Slack application editor (or manifest json/yaml if using).

First time using a particular ngrok url, will get warning, that's ok, allow:
![ngrok warning ok](docs/ngrok-warning-ok.png)

URL of this page is - i.e. Slack is providing the one-time code (that we later need to exchange for a token):
```
https://0123-123-123-123-123.ngrok-free.app/auth/slack/callback?
  scope=incoming-webhook&
  client_id=123456&
  code=123abcdef&
  state=
```

`app/controllers/slack_auth_controller.rb` will handle this request, it extracts the `code` and optional `state` parameters, then makes another request to Slack (POST or GET?) to exchange the code for an `access_token`. This token then gets persisted in the `teams` table.

## Scopes

* commands - for bot to use slash commands
* chat:write - for bot to post messages to channel
* users:read - for bot to list users in channel (needed by slack gem `ping`)
* chat:write.public - For your new Slack app to gain the ability to post in all public channels
