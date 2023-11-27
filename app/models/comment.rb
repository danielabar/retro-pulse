# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  anonymous        :boolean          default(FALSE), not null
#  category         :enum             default("keep"), not null
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
class Comment < ApplicationRecord
  belongs_to :retrospective

  enum category: {
    keep: "keep",
    stop: "stop",
    try: "try"
  }

  validates :content, presence: true
  validates :anonymous, inclusion: { in: [true, false] }
end
