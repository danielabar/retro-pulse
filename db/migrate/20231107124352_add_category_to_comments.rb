class AddCategoryToComments < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL.squish
      CREATE TYPE comment_category AS ENUM ('keep', 'stop', 'try');
    SQL
    add_column :comments, :category, :comment_category, default: "keep", null: false
  end

  def down
    remove_column :comments, :category
    execute <<-SQL.squish
      DROP TYPE comment_category;
    SQL
  end
end
