class CreateMemberships < ActiveRecord::Migration[8.0]
  def up
    return if table_exists?(:memberships)

    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      # t.integer :role, null: false, default: 0
      t.string :role, null: false, default: "member"
      t.string :status, null: false, default: "pending"
      t.string     :invitation_token
      t.datetime   :invitation_sent_at

      t.timestamps
    end

    add_index :memberships, [:user_id, :organization_id], unique: true
    add_index :memberships, :invitation_token, unique: true
  end

  def down
    drop_table :memberships if table_exists?(:memberships)
  end
end
