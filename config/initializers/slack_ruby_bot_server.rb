SlackRubyBotServer.configure do |config|
  # Is this needed?
  # config.view_paths << File.expand_path(File.join(__dir__, "../../public"))
  config.oauth_version = :v2
  config.oauth_scope = ["commands", "chat:write", "users:read", "chat:write.public"]
end
