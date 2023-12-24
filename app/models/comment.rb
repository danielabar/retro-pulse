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
class Comment < ApplicationRecord
  belongs_to :retrospective

  enum category: {
    keep: "keep",
    stop: "stop",
    try: "try"
  }

  validates :content, presence: true
  validates :anonymous, inclusion: { in: [true, false] }

  # These validations must match the `check_slack_info_if_not_anonymous` check constraint on the `comments` table:
  validates :slack_user_id, absence: { message: "must be empty when anonymous is true" }, if: :anonymous
  validates :slack_username, absence: { message: "must be empty when anonymous is true" }, if: :anonymous
  validates :slack_user_id, presence: { message: "must be provided when anonymous is false" }, unless: :anonymous
  validates :slack_username, presence: { message: "must be provided when anonymous is false" }, unless: :anonymous

  def user_info
    anonymous? ? "anonymous" : slack_username
  end
end
