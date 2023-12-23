class SaveRetrospectiveFeedback
  include Interactor
  include ActionView::Helpers::SanitizeHelper
  include SlackFormParser

  def call
    parse_payload
    save_comment
    send_feedback_confirmation
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

  def parse_payload
    @user_info = parse_user_info(context.payload)
    @feedback_info = parse_feedback_info(context.payload)
  end

  def save_comment
    retrospective = Retrospective.open_retrospective.first

    comment = Comment.new(
      content: @feedback_info[:comment],
      anonymous: @feedback_info[:anonymous],
      category: @feedback_info[:category],
      retrospective:,
      **slack_fields
    )

    context.message = if comment.save
                        "Thank you, your `#{@feedback_info[:category]}` feedback has been submitted."
                      else
                        "Could not save your `#{@feedback_info[:category]}` feedback: #{comment.errors.full_messages}"
                      end
  end

  def slack_fields
    if @feedback_info[:anonymous]
      { slack_user_id: nil, slack_username: nil }
    else
      { slack_user_id: @user_info[:slack_user_id], slack_username: @user_info[:slack_username] }
    end
  end

  def send_feedback_confirmation
    context.slack_client.chat_postMessage(
      channel: @user_info[:user_id],
      text: context.message
    )
  end

  def log_error(error)
    error_message = "Error in SaveRetrospectiveFeedback: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
