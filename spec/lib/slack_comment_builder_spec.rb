require "rails_helper"

RSpec.describe SlackCommentBuilder do
  let(:first_comment) { build_stubbed(:comment, content: "foo", created_at: 1.day.ago) }
  let(:second_comment) { build_stubbed(:comment, content: "bar", anonymous: true, created_at: 2.days.ago) }
  let(:comments) { [first_comment, second_comment] }

  describe ".build_header_block" do
    it "builds a header block for comments" do
      header_block = described_class.build_header_block(comments, "What we should keep doing")

      expect(header_block[0]).to eq({ type: "header",
                                      text: { type: "plain_text", text: "What we should keep doing" } })
      expect(header_block[1]).to eq({ type: "section",
                                      text: { type: "mrkdwn", text: "Found *2* comments in this category:" } })
      expect(header_block[2]).to eq({ type: "divider" })
    end
  end

  describe ".build_comment_blocks" do
    it "builds a section, context, and divider for each comment" do
      comment_blocks = described_class.build_comment_blocks(comments)

      expect(comment_blocks[0]).to eq({ type: "section", text: { type: "mrkdwn", text: "foo" } })
      expect(comment_blocks[1]).to eq({ type: "context",
                                        elements: [{ type: "plain_text", emoji: true,
                                                     text: ":bust_in_silhouette: jane.smith" },
                                                   { type: "plain_text", emoji: true,
                                                     text: ":calendar: #{1.day.ago.strftime('%Y-%m-%d')}" }] })
      expect(comment_blocks[2]).to eq({ type: "divider" })

      expect(comment_blocks[3]).to eq({ type: "section", text: { type: "mrkdwn", text: "bar" } })
      expect(comment_blocks[4]).to eq({ type: "context",
                                        elements: [{ type: "plain_text", emoji: true,
                                                     text: ":bust_in_silhouette: anonymous" },
                                                   { type: "plain_text", emoji: true,
                                                     text: ":calendar: #{2.days.ago.strftime('%Y-%m-%d')}" }] })
      expect(comment_blocks[5]).to eq({ type: "divider" })
    end
  end
end
