require "rails_helper"

RSpec.describe CloseRetrospective, type: :interactor do
  let(:channel_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, chat_postMessage: nil) }

  describe ".call" do
    context "when there exists an open retrospective" do
      let!(:retrospective) { create(:retrospective) }

      it "closes the open retrospective and posts a confirmation message" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(retrospective.reload.closed?).to be(true)
        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          mrkdwn: true,
          text: ":closed_book: Closed retrospective `#{retrospective.title}`"
        )
      end
    end

    context "when there does not exist an open retrospective" do
      it "posts an error message" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          text: ":warning: There is no open retrospective."
        )
      end
    end

    context "when an unexpected error occurs" do
      it "logs the error and fails the context" do
        allow(Rails.logger).to receive(:error)
        allow(slack_client).to receive(:chat_postMessage).and_raise(StandardError, "Slack client error")

        result = described_class.call(channel_id:, slack_client:)
        expect(result).to be_a_failure

        expect(Rails.logger).to have_received(:error).with(
          a_string_starting_with("Error in CloseRetrospective: Slack client error")
        )
      end
    end
  end
end
