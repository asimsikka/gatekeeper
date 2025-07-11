class AddDobAndParentalConsentToUsers < ActiveRecord::Migration[8.0]
  def up
    return unless table_exists?(:users)

    add_column :users, :date_of_birth, :date unless column_exists?(:users, :date_of_birth)
    add_column :users, :first_name, :string  unless column_exists?(:users, :first_name)
    add_column :users, :parental_consent, :boolean, default: false, null: false unless column_exists?(:users, :parental_consent)
  end

  def down
    return unless table_exists?(:users)

    remove_column :users, :date_of_birth if column_exists?(:users, :date_of_birth)
    remove_column :users, :first_name if column_exists?(:users, :first_name)
    remove_column :users, :last_name if column_exists?(:users, :last_name)
    remove_column :users, :parental_consent if column_exists?(:users, :parental_consent)
  end
end
