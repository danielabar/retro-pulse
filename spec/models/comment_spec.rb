# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  anonymous        :boolean          default(FALSE), not null
#  category         :enum             default("keep"), not null
#  content          :text             not null
#  slack_username   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  retrospective_id :bigint           not null
#  slack_user_id    :string
#
# Indexes
#
#  index_comments_on_retrospective_id  (retrospective_id)
#
# Foreign Keys
#
#  fk_rails_...  (retrospective_id => retrospectives.id)
#
require "rails_helper"

RSpec.describe Comment do
  subject(:comment) { build_stubbed(:comment) }

  describe "associations" do
    it { is_expected.to belong_to(:retrospective) }
  end

  describe "validations" do
    it "validates presence of content" do
      comment = described_class.new(content: nil)
      comment.valid?
      expect(comment.errors[:content]).to include("can't be blank")
    end

    it "has a default value of false for anonymous" do
      expect(comment).to have_attributes(anonymous: false)
    end

    it "validates absence of slack_user_id when anonymous is true" do
      comment = described_class.new(anonymous: true, slack_user_id: "abc123")
      comment.valid?
      expect(comment.errors[:slack_user_id]).to include("must be empty when anonymous is true")
    end

    it "validates absence of slack_username when anonymous is true" do
      comment = described_class.new(anonymous: true, slack_username: "jane.smith")
      comment.valid?
      expect(comment.errors[:slack_username]).to include("must be empty when anonymous is true")
    end

    it "validates presence of slack_user_id when anonymous is false" do
      comment = described_class.new(anonymous: false, slack_user_id: nil)
      comment.valid?
      expect(comment.errors[:slack_user_id]).to include("must be provided when anonymous is false")
    end

    it "validates presence of slack_username when anonymous is false" do
      comment = described_class.new(anonymous: false, slack_username: nil)
      comment.valid?
      expect(comment.errors[:slack_username]).to include("must be provided when anonymous is false")
    end

    it "is valid when anonymous is false and slack info is populated" do
      comment = build_stubbed(:comment, anonymous: false, slack_user_id: "abc123", slack_username: "jane.smith")
      expect(comment).to be_valid
    end

    it "is valid when anonymous is true and slack info is not populated" do
      comment = build_stubbed(:comment, anonymous: true, slack_user_id: nil, slack_username: nil)
      expect(comment).to be_valid
    end
  end

  describe "enum" do
    it {
      expect(comment).to define_enum_for(:category)
        .with_values(keep: "keep", stop: "stop", try: "try")
        .backed_by_column_of_type(:enum)
    }
  end

  describe ".header" do
    it "returns header text for 'keep' category" do
      expect(described_class.header(:keep)).to eq("What we should keep on doing")
    end

    it "returns header text for 'stop' category" do
      expect(described_class.header(:stop)).to eq("What we should stop doing")
    end

    it "returns header text for 'try' category" do
      expect(described_class.header(:try)).to eq("Something to try for next time")
    end

    it "returns 'Unknown category' for an unknown category" do
      expect(described_class.header(:unknown)).to eq("Unknown category")
    end
  end
end
