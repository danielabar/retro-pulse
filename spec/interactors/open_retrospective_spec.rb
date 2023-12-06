require "rails_helper"

RSpec.describe OpenRetrospective, type: :interactor do
  let(:command_text) { "New Retro" }
  let(:channel_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, chat_postMessage: nil) }

  describe ".call" do
    context "when retro is created successfully" do
      it "creates a retrospective and sends success message" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(command_text:, channel_id:, slack_client:)
        expect(result).to be_a_success

        retro = Retrospective.find_by(title: command_text)
        expect(retro).to have_attributes(
          title: command_text,
          status: "open"
        )

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          text: "Created retro #{command_text}, view it at https://#{ENV.fetch('SERVER_HOST_NAME')}/retrospectives/#{retro.id}"
        )
      end

      # TODO: verify strips whitespace
    end

    # WIP Try to create a retro that already exists by name or already have an open one
    context "when retro cannot be created due to validation error" do
      it "sends an error message to the user" do
        allow(slack_client).to receive(:chat_postMessage)
        result = described_class.call(command_text:, channel_id:, slack_client:)
        expect(result).to be_a_failure
        expect(result.error_message).to eq("Could not create retro New Retro, error: Validation error")
      end
    end

    # WIP
    context "when an unexpected situation occurs" do
      it "logs the error and fails the context" do
        allow(Rails.logger).to receive(:error).twice
        allow(slack_client).to receive(:chat_postMessage).and_raise(StandardError, "Slack client error")
        result = described_class.call(command_text:, channel_id:, slack_client:)
        expect(result).to be_a_failure
        expect(result.error_message).to eq("An error occurred while opening the retrospective.")
      end
    end
  end
end
