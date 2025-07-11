class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :body
      t.integer :age_rating, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :content_space, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contents, :age_rating
  end
end
