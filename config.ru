# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# This is super important, without it, all commands just do nothing and return 204 No Content
require_relative "bot/slash_commands"
require_relative "bot/actions"
# maybe don't need events for this app
# require_relative "bot/events"
# This will create the `teams` table if doesn't already exist
SlackRubyBotServer::App.instance.prepare!

run Rails.application
Rails.application.load_server
