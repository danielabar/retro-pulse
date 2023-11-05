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
FactoryBot.define do
  factory :retrospective do
    title { "#{Faker::App.name} - #{Faker::App.semantic_version}" }
  end
end
