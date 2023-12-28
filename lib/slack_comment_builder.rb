module SlackCommentBuilder
  module_function

  def build_header_block(comments, category_display)
    [
      build_header(category_display),
      build_section("Found *#{comments.size}* comments in this category:"),
      build_divider
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

  def build_header(category_display)
    {
      type: "header",
      text: {
        type: "plain_text",
        text: category_display
      }
    }
  end

  def build_section(text)
    {
      type: "section",
      text: {
        type: "mrkdwn",
        text:
      }
    }
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

  def build_comment_context(comment)
    {
      type: "context",
      elements: [
        build_context_element(":bust_in_silhouette: #{comment.user_info}"),
        build_context_element(":calendar: #{comment.created_at.strftime('%Y-%m-%d')}")
      ]
    }
  end

  def build_context_element(text)
    {
      type: "plain_text",
      emoji: true,
      text:
    }
  end

  def build_divider
    { type: "divider" }
  end
end
