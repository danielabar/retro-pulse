class AddSlackUserIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :slack_user_id, :string
  end
end
