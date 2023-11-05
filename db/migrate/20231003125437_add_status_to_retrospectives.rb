class AddStatusToRetrospectives < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL.squish
      CREATE TYPE retrospective_status AS ENUM ('open', 'closed');
    SQL
    add_column :retrospectives, :status, :retrospective_status, default: "open", null: false
  end

  def down
    remove_column :retrospectives, :status
    execute <<-SQL.squish
      DROP TYPE retrospective_status;
    SQL
  end
end
