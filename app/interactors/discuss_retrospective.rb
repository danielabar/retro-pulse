class DiscussRetrospective
  include Interactor
  include SlackCommentBuilder

  # TODO: What if there is no open retro?
  # TODO: What if did not receive any category?
  # TODO: What if received invalid cateogry?
  def call
    retrospective = Retrospective.open_retrospective.first
    comments = retrospective.comments_by_category(category: context.category)
    post_message(comments)
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

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

  def log_error(error)
    error_message = "Error in DiscussRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
