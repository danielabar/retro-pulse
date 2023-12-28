class DiscussRetrospective
  include Interactor
  include SlackCommentBuilder

  def call
    retrospective = Retrospective.open_retrospective.first
    return no_open_retrospective_message if retrospective.nil?

    category = extract_valid_category
    return invalid_category_message unless category

    comments = retrospective.comments_by_category(category: context.category)
    post_message(comments)
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

  def no_open_retrospective_message
    message = "There is no open retrospective. Please run `/retro-open` to open one."
    send_error_message(message)
  end

  def extract_valid_category
    category = context.category&.to_sym
    return category if Comment.categories.key?(category)

    nil
  end

  def invalid_category_message
    valid_categories = Comment.categories.keys.map(&:to_s).join(", ")
    message = "Invalid discussion category. Please provide a valid category (#{valid_categories})."
    send_error_message(message)
  end

  def post_message(comments)
    blocks = build_header_block(comments, Comment.header(context.category))
    blocks += build_comment_blocks(comments)
    send_message(blocks)
  end

  def send_message(blocks)
    # If Slack responds with "invalid blocks" error, take this output, convert to JSON,
    # and paste it in Slack's Block Kit Builder to see what's wrong.
    Rails.logger.debug { "=== BLOCKS: #{blocks.inspect}" }
    context.slack_client.chat_postMessage(
      channel: context.channel_id,
      text: "fallback TBD",
      blocks:
    )
  end

  def send_error_message(text)
    context.slack_client.chat_postMessage(
      channel: context.channel_id,
      text:
    )
  end

  def log_error(error)
    error_message = "Error in DiscussRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
