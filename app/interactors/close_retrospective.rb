class CloseRetrospective
  include Interactor

  # Close the currently open retrospective and post confirmation message
  # in the Slack channel.
  #
  # @example
  #   CloseRetrospective.call(channel_id: "123", slack_client: Slack::Web::Client.new)
  #
  # @param [String] channel_id The ID of the Slack channel where the command was issued.
  # @param [Slack::Web::Client] slack_client An instance of the Slack client for communication.
  # @return [void]
  def call
    @retrospective = Retrospective.open_retrospective.first
    return no_open_retrospective_message if @retrospective.nil?

    @retrospective.closed!
    handle_successful_close
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

  def handle_successful_close
    message = ":closed_book: Closed retrospective `#{@retrospective.title}`"
    post_message(message)
  end

  def post_message(message)
    context.slack_client.chat_postMessage(
      channel: context.channel_id,
      mrkdwn: true,
      text: message
    )
  end

  def no_open_retrospective_message
    message = "There is no open retrospective."
    send_error_message(message)
  end

  def send_error_message(text)
    warning_icon = ":warning:"
    context.slack_client.chat_postMessage(
      channel: context.channel_id,
      text: "#{warning_icon} #{text}"
    )
  end

  def log_error(error)
    error_message = "Error in CloseRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
