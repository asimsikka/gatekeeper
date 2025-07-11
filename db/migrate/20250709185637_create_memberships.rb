class CreateMemberships < ActiveRecord::Migration[8.0]
  def up
    return if table_exists?(:memberships)

    create_table :memberships do |t|
      t.references :user, null: true, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :role, null: false, default: "member"
      t.string :status, null: false, default: "invited"
      t.string :invite_email
      t.string     :invitation_token
      t.datetime   :invitation_sent_at

      t.timestamps
    end

    add_index :memberships, [:user_id, :organization_id], unique: true
    add_index :memberships, :invitation_token, unique: true
    add_index  :memberships, :invite_email
  end

  def down
    drop_table :memberships if table_exists?(:memberships)
  end
end
