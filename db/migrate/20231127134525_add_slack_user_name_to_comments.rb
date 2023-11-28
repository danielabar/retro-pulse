class AddSlackUserNameToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :slack_username, :string
  end
end
