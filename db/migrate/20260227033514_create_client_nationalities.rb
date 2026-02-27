class CreateClientNationalities < ActiveRecord::Migration[8.1]
  def change
    create_table :client_nationalities do |t|
      t.references :client, null: false, foreign_key: true
      t.string :country_code, limit: 2, null: false

      t.timestamps
    end

    add_index :client_nationalities, [:client_id, :country_code], unique: true
  end
end
