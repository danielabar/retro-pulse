class AddCheckConstraintForSlackInfoInComments < ActiveRecord::Migration[7.0]
  def change
    # If a comment is anonymous, then the slack info fields should be null.
    # If a comment is not anonymous, then the slack info fields should be populated.
    add_check_constraint(
      :comments,
      "(anonymous AND slack_user_id IS NULL AND slack_username IS NULL) OR (NOT anonymous AND slack_user_id IS NOT NULL AND slack_username IS NOT NULL)",
      name: "check_slack_info_if_not_anonymous"
    )
  end
end
