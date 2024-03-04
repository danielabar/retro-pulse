require "rails_helper"

RSpec.describe InitiateFeedbackForm, type: :interactor do
  let(:trigger_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, views_open: nil) }
  let(:user_id) { "123456" }

  describe ".call" do
    context "when an open retro exists" do
      it "opens Slack modal" do
        create(:retrospective)
        allow(slack_client).to receive(:views_open)

        result = described_class.call(trigger_id:, slack_client:, user_id:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:views_open)
      end
    end

    context "when no open retro exists" do
      it "responds with DM to user and does not open modal" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(trigger_id:, slack_client:, user_id:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: user_id,
          text: ":warning: There is no open retrospective. Please run `/retro-open` to open one."
        )
        expect(slack_client).not_to have_received(:views_open)
      end
    end

    context "when Slack API returns an error" do
      it "logs an error" do
        create(:retrospective)
        allow(Rails.logger).to receive(:error)
        allow(slack_client).to receive(:views_open).and_raise(StandardError, "Slack client error")

        result = described_class.call(trigger_id:, slack_client:, user_id:)
        expect(result).to be_a_failure

        expect(Rails.logger).to have_received(:error).with(
          a_string_starting_with("Error in InitiateFeedbackForm: Slack client error")
        )
      end
    end
  end
end
