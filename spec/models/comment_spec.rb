# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  anonymous        :boolean          default(FALSE), not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  retrospective_id :bigint           not null
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
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:anonymous) }

    it "has a default value of false for anonymous" do
      expect(comment).to have_attributes(anonymous: false)
    end
  end
end
