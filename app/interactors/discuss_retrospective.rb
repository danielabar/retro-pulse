class DiscussRetrospective
  include Interactor
  include ActionView::Helpers::SanitizeHelper

  def call
    retrospective = Retrospective.open_retrospective.first
  rescue StandardError => e
    log_error(e)
    context.fail!
  end

  private

  def log_error(error)
    error_message = "Error in DiscussRetrospective: #{error.message}"
    backtrace = error.backtrace.join("\n")
    Rails.logger.error("#{error_message}\n#{backtrace}")
  end
end
