class OpenRetrospective
  include Interactor
  include ActionView::Helpers::SanitizeHelper

  # Create a new retrospective in `open` status with the given text,
  # and reply back in channel with url of newly created retrospective.
  # HTML tags and leading/trailing whitespace will be removed from text.
  #
  # @example
  #   OpenRetrospective.call(title: "New Retro", channel_id: "123", slack_client: Slack::Web::Client.new)
  #
  # @param [String] title The title for the retrospective.
  # @param [String] channel_id The ID of the Slack channel where the command was issued.
  # @param [Slack::Web::Client] slack_client An instance of the Slack client for communication.
  # @return [void]
  def call
    initialize_retrospective
    process_retrospective
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

  def initialize_retrospective
    @title = strip_tags(context.title).strip
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
    message = ":memo: Opened retro `#{@retrospective.title}`"
    post_message(message)
  end

  def handle_failed_save
    error_message = ":warning: Could not create retro `#{@title}`, error: #{@retrospective.errors.full_messages}"
    post_message(error_message)
  end

  def post_message(message)
    context.slack_client.chat_postMessage(
      channel: context.channel_id,
      mrkdwn: true,
      text: message
    )
  end

  def log_error(error)
    error_message = "Error in OpenRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
