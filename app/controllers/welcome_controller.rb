class WelcomeController < ApplicationController
  def index
    @slack_oauth_url = build_slack_oauth_url
  end

  private

  def build_slack_oauth_url
    scope = SlackRubyBotServer::Config.oauth_scope_s
    client_id = ENV.fetch("SLACK_CLIENT_ID", nil)
    SlackRubyBotServer::Config.oauth_authorize_url + "?scope=#{scope}&client_id=#{client_id}"
  end
end
