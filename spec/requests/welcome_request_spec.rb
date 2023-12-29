require "rails_helper"
require "cgi"

RSpec.describe "Welcome" do
  describe "GET /" do
    it "includes the Slack OAuth URL" do
      get root_path

      # Compare the response body after unescaping HTML entities
      expect(unescape_html(response.body)).to include(build_expected_oauth_url)
    end

    def build_expected_oauth_url
      scope = SlackRubyBotServer::Config.oauth_scope_s
      client_id = ENV.fetch("SLACK_CLIENT_ID", nil)
      "#{SlackRubyBotServer::Config.oauth_authorize_url}?scope=#{scope}&client_id=#{client_id}"
    end

    # Unescape HTML entities in a given HTML string
    def unescape_html(html)
      CGI.unescapeHTML(html)
    end
  end
end
