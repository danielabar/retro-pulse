require "rails_helper"

RSpec.describe OpenRetrospective, type: :interactor do
  let(:channel_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, chat_postMessage: nil) }

  describe ".call" do
    context "when retro is created successfully" do
      it "creates a retrospective and sends success message via Slack" do
        allow(slack_client).to receive(:chat_postMessage)

        title = "Project Zenith Sprint 3"
        result = described_class.call(title:, channel_id:, slack_client:)
        expect(result).to be_a_success

        retro = Retrospective.find_by(title:)
        expect(retro).to have_attributes(
          title:,
          status: Retrospective.statuses[:open]
        )

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          mrkdwn: true,
          text: ":memo: Opened retro <https://#{ENV.fetch('SERVER_HOST_NAME')}/retrospectives/#{retro.id}|#{title}>"
        )
      end

      it "removes whitespace from title" do
        allow(slack_client).to receive(:chat_postMessage)

        title = "         some_title          "
        result = described_class.call(title:, channel_id:, slack_client:)
        expect(result).to be_a_success

        retro = Retrospective.find_by(title: "some_title")
        expect(retro).to have_attributes(
          title: "some_title",
          status: Retrospective.statuses[:open]
        )

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          mrkdwn: true,
          text: ":memo: Opened retro <https://#{ENV.fetch('SERVER_HOST_NAME')}/retrospectives/#{retro.id}|some_title>"
        )
      end

      it "removes html tags from title" do
        allow(slack_client).to receive(:chat_postMessage)

        title = "<b>text</b>"
        result = described_class.call(title:, channel_id:, slack_client:)
        expect(result).to be_a_success

        retro = Retrospective.find_by(title: "text")
        expect(retro).to have_attributes(
          title: "text",
          status: Retrospective.statuses[:open]
        )

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          mrkdwn: true,
          text: ":memo: Opened retro <https://#{ENV.fetch('SERVER_HOST_NAME')}/retrospectives/#{retro.id}|text>"
        )
      end
    end

    context "when retro cannot be created due to validation error" do
      it "does not create retrospective and sends error message with reason via Slack" do
        create(:retrospective, status: Retrospective.statuses[:open])
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(title: "foo", channel_id:, slack_client:)
        expect(result).to be_a_failure

        expect(Retrospective.find_by(title: "foo")).to be_nil

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          mrkdwn: true,
          text: "Could not create retro `foo`, error: [\"Status There can only be one open retrospective at a time.\"]"
        )
      end
    end

    context "when an unexpected error occurs" do
      it "logs the error and fails the context" do
        allow(Rails.logger).to receive(:error)
        allow(slack_client).to receive(:chat_postMessage).and_raise(StandardError, "Slack client error")

        result = described_class.call(title: "some title", channel_id:, slack_client:)
        expect(result).to be_a_failure

        expect(Rails.logger).to have_received(:error).with(
          a_string_starting_with("Error in OpenRetrospective: Slack client error")
        )
      end
    end
  end
end
