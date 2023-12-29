require "rails_helper"

RSpec.describe DiscussRetrospective, type: :interactor do
  let(:channel_id) { "123" }
  let(:slack_client) { instance_double(Slack::Web::Client, chat_postMessage: nil) }

  describe ".call" do
    context "when there exists an open retrospective" do
      let!(:retrospective) { create(:retrospective) }

      it "posts a message with comments for that category when category is valid and have comments" do
        comments = create_list(:comment, 2, retrospective:, category: Comment.categories[:stop])
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(category: Comment.categories[:stop], channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          hash_including(
            channel: channel_id,
            text: "fallback TBD",
            blocks: include(
              { type: "header", text: { type: "plain_text", text: "What we should stop doing" } },
              { type: "section", text: { type: "mrkdwn", text: "Found *2* comments in this category:" } },
              { type: "section", text: { type: "mrkdwn", text: comments[0].content } },
              { type: "section", text: { type: "mrkdwn", text: comments[1].content } }
            )
          )
        )
      end

      it "posts a message with 0 comments when there are no comments in the requested category" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(category: Comment.categories[:try], channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          hash_including(
            channel: channel_id,
            text: "fallback TBD",
            blocks: include(
              { type: "header", text: { type: "plain_text", text: "Something to try for next time" } },
              { type: "section", text: { type: "mrkdwn", text: "Found *0* comments in this category:" } }
            )
          )
        )
      end

      it "posts an error message when given an invalid cateogry" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(category: "foo", channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          text: ":warning: Invalid discussion category. Please provide a valid category (keep, stop, try)."
        )
      end

      it "posts an error message when given nil for category" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(category: nil, channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          text: ":warning: Invalid discussion category. Please provide a valid category (keep, stop, try)."
        )
      end
    end

    context "when there does not exist an open retrospective" do
      it "posts an error message" do
        allow(slack_client).to receive(:chat_postMessage)

        result = described_class.call(category: Comment.categories[:keep], channel_id:, slack_client:)
        expect(result).to be_a_success

        expect(slack_client).to have_received(:chat_postMessage).with(
          channel: channel_id,
          text: ":warning: There is no open retrospective. Please run `/retro-open` to open one."
        )
      end
    end

    context "when an unexpected error occurs" do
      it "logs the error and fails the context" do
        allow(Rails.logger).to receive(:error)
        allow(slack_client).to receive(:chat_postMessage).and_raise(StandardError, "Slack client error")

        result = described_class.call(category: Comment.categories[:keep], channel_id:, slack_client:)
        expect(result).to be_a_failure

        expect(Rails.logger).to have_received(:error).with(
          a_string_starting_with("Error in DiscussRetrospective: Slack client error")
        )
      end
    end
  end
end
