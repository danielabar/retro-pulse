# Interactor for opening a retrospective.
class OpenRetrospective
  include Interactor

  # Interactor entry point.
  #
  # @example
  #   OpenRetrospective.call(command_text: "New Retro", channel_id: "123", slack_client: Slack::Web::Client.new)
  #
  # @param [String] command_text The title for the retrospective.
  # @param [String] channel_id The ID of the Slack channel where the command was issued.
  # @param [Slack::Web::Client] slack_client An instance of the Slack client for communication.
  # @return [void]
  def call
    initialize_retrospective
    process_retrospective
  rescue StandardError => e
    log_error(e)
    context.fail!(error_message: "An error occurred while opening the retrospective.")
  end

  private

  def initialize_retrospective
    @title = context.command_text.strip
    @retrospective = Retrospective.new(title: @title)
  end

  def process_retrospective
    if @retrospective.save
      handle_successful_save
    else
      handle_failed_save
    end
  end

  def handle_successful_save
    url = retrospective_url
    post_message("Created retro #{@title}, view it at #{url}")
  end

  def handle_failed_save
    error_message = @retrospective.errors.full_messages
    post_message("Could not create retro #{@title}, error: #{error_message}")
  end

  def retrospective_url
    Rails.application.routes.url_helpers.retrospective_url(
      @retrospective, host: ENV.fetch("SERVER_HOST_NAME"), protocol: "https"
    )
  end

  def post_message(message)
    context.slack_client.chat_postMessage(channel: context.channel_id, text: message)
  end

  def log_error(error)
    error_message = "Error in OpenRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    error_log = "#{error_message}\n#{backtrace}"
    Rails.logger.error(error_log)
  end
end
