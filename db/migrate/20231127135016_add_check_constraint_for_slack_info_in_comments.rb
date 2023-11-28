class AddCheckConstraintForSlackInfoInComments < ActiveRecord::Migration[7.0]
  def change
    # If a comment is not anonymous, then both slack_user_id and slack_username must have values (not be NULL).
    # If a comment is anonymous, it doesn't enforce the non-null constraint on the slack_user_id and slack_username.
    add_check_constraint(
      :comments,
      "(NOT anonymous) AND (slack_user_id IS NOT NULL AND slack_username IS NOT NULL)",
      name: "check_slack_info_if_not_anonymous"
    )
  end
end
