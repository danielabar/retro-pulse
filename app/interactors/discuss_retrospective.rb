class DiscussRetrospective
  include Interactor
  include ActionView::Helpers::SanitizeHelper

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
    blocks = build_header_block(comments)
    blocks += build_comment_blocks(comments)
    send_message(blocks)
  end

  def build_header_block(comments)
    [
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "There are *#{comments.size}* `#{context.category}` comments"
        }
      },
      { type: "divider" }
    ]
  end

  def build_comment_blocks(comments)
    comments.flat_map do |comment|
      [
        build_comment_content(comment),
        build_comment_context(comment),
        build_divider
      ]
    end
  end

  def build_comment_content(comment)
    {
      type: "section",
      text: {
        type: "mrkdwn",
        text: comment.content
      }
    }
  end

  # displays nicely small, but no way to do side by side?
  # def build_comment_context(comment)
  #   {
  #     type: "context",
  #     elements: [
  #       {
  #         type: "plain_text",
  #         emoji: true,
  #         text: ":bust_in_silhouette: #{comment.user_info}"
  #       },
  #       {
  #         type: "plain_text",
  #         emoji: true,
  #         text: ":date: #{comment.created_at.strftime('%Y-%m-%d')}"
  #       }
  #     ]
  #   }
  # end

  # displays side-by-side, but too big
  def build_comment_context(comment)
    {
      type: "section",
      fields: [
        {
          type: "plain_text",
          text: ":bust_in_silhouette: #{comment.user_info}"
        },
        {
          type: "plain_text",
          text: ":date: #{comment.created_at.strftime('%Y-%m-%d')}"
        }
      ]
    }
  end

  def build_divider
    { type: "divider" }
  end

  def send_message(blocks)
    # temp debug
    Rails.logger.info("=== BLOCKS: #{blocks.inspect}")
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
