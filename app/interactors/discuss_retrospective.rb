class DiscussRetrospective
  include Interactor
  include ActionView::Helpers::SanitizeHelper

  def call
    # what if there is no open retro, this could return nil
    retrospective = Retrospective.open_retrospective.first
    # what if the given category isn't valid
    # what if there are no comments of the given category?
    comments = retrospective.comments.where(category: context.category)
    # temp debug
    puts comments.inspect
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

  def incident_attachment(incident)
    {
      title: incident.title,
      text: incident.description,
      fields: [
        { title: "Severity", value: incident.severity, short: true },
        { title: "Creator", value: incident.created_by, short: true }
      ]
    }
  end
end
