class CreateContentSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :content_spaces do |t|
      t.string :name
      t.integer :min_age, null: false, default: 0
      t.integer :max_age, null: false, default: 150
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :content_spaces, [:organization_id, :name], unique: true
  end
end
