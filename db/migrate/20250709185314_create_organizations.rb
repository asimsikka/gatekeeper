class CreateOrganizations < ActiveRecord::Migration[8.0]
  def up
    return if table_exists?(:organizations)

    create_table :organizations do |t|
      t.string :name, null: false
      t.text   :description
      t.string :location
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :organizations, :name
  end

  def down
    drop_table :organizations if table_exists?(:organizations)
  end
end
