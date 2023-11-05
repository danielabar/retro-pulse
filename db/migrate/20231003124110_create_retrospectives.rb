class CreateRetrospectives < ActiveRecord::Migration[7.0]
  def change
    create_table :retrospectives do |t|
      t.string :title, null: false

      t.timestamps
    end
    add_index :retrospectives, :title, unique: true
  end
end
