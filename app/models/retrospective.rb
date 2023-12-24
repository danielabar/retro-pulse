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

  enum status: {
    open: "open",
    closed: "closed"
  }

  validates :title, presence: true, uniqueness: true
  validates :status, presence: true
  validate :only_one_open_retrospective

  scope :open_retrospective, -> { where(status: statuses[:open]) }

  def comments_by_category(category:)
    comments.where(category:)
  end

  private

  def only_one_open_retrospective
    return unless open? && Retrospective.exists?(status: "open")

    errors.add(:status, "There can only be one open retrospective at a time.")
  end
end
