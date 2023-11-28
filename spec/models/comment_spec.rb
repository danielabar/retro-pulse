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

    it "validates presence of slack_user_id when not anonymous" do
      comment = described_class.new(anonymous: false, slack_user_id: nil)
      comment.valid?
      expect(comment.errors[:slack_user_id]).to include("can't be blank")
    end

    it "validates presence of slack_username when not anonymous" do
      comment = described_class.new(anonymous: false, slack_username: nil)
      comment.valid?
      expect(comment.errors[:slack_username]).to include("can't be blank")
    end
  end

  describe "enum" do
    it {
      expect(comment).to define_enum_for(:category)
        .with_values(keep: "keep", stop: "stop", try: "try")
        .backed_by_column_of_type(:enum)
    }
  end
end
