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
FactoryBot.define do
  factory :comment do
    retrospective
    content { Faker::Lorem.paragraph }
    anonymous { false }
    slack_user_id { "abc123" }
    slack_username { "jane.smith" }
  end
end
