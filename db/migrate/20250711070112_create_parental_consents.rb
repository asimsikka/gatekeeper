class CreateParentalConsents < ActiveRecord::Migration[8.0]
  def change
    create_table :parental_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :guardian_email, null: false
      t.string :token, null: false
      t.boolean :approved, null: false, default: false
      t.datetime :approved_at

      t.timestamps
    end

    add_index :parental_consents, :token, unique: true
  end
end
