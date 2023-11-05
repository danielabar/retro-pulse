# == Schema Information
#
# Table name: retrospectives
#
#  id         :bigint           not null, primary key
#  status     :enum             default("open"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_retrospectives_on_title  (title) UNIQUE
#
class Retrospective < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :status, presence: true

  enum status: {
    open: "open",
    closed: "closed"
  }
end
