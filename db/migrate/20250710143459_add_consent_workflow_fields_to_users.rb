class AddConsentWorkflowFieldsToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :consent_token, :string unless column_exists?(:users, :consent_token)
    add_column :users, :consent_sent_at, :datetime unless column_exists?(:users, :consent_sent_at)
    add_column :users, :consent_approved_at, :datetime unless column_exists?(:users, :consent_approved_at)

    add_index :users, :consent_token, unique: true
  end

  def down
    remove_column :users, :consent_token if column_exists?(:users, :consent_token)
    remove_column :users, :consent_sent_at if column_exists?(:users, :consent_sent_at)
    remove_column :users, :consent_approved_at if column_exists?(:users, :consent_approved_at)
  end
end
