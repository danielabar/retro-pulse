require "rails_helper"

RSpec.describe InitiateFeedbackForm, type: :interactor do
  let(:trigger_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, views_open: nil) }

  describe ".call" do
    context "when successful" do
      it "opens Slack modal" do
        allow(slack_client).to receive(:views_open)

        result = described_class.call(trigger_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:views_open)
      end
    end

    context "when unsuccessful" do
      it "logs an error" do
        allow(Rails.logger).to receive(:error)
        allow(slack_client).to receive(:views_open).and_raise(StandardError, "Slack client error")

        result = described_class.call(trigger_id:, slack_client:)
        expect(result).to be_a_failure

        expect(Rails.logger).to have_received(:error).with(
          a_string_starting_with("Error in InitiateFeedbackForm: Slack client error")
        )
      end
    end
  end
end
