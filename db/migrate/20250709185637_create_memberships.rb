class CreateMemberships < ActiveRecord::Migration[8.0]
  def up
    return if table_exists?(:memberships)

    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :memberships if table_exists?(:memberships)
  end
end
