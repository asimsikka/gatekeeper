class AddDobAndParentalConsentToUsers < ActiveRecord::Migration[8.0]
  def up
    return unless table_exists?(:users)

    unless column_exists?(:users, :date_of_birth)
      add_column :users, :date_of_birth, :date
    end

    unless column_exists?(:users, :parental_consent)
      add_column :users, :parental_consent, :boolean, default: false, null: false
    end
  end

  def down
    return unless table_exists?(:users)

    if column_exists?(:users, :date_of_birth)
      remove_column :users, :date_of_birth
    end

    if column_exists?(:users, :parental_consent)
      remove_column :users, :parental_consent
    end
  end
end
