class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.boolean :anonymous, null: false, default: false
      t.references :retrospective, null: false, foreign_key: true

      t.timestamps
    end
  end
end
