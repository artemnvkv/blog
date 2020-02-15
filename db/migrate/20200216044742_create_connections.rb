class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address, nul: false
      t.index %i[ip_address user_id], unique: true

      t.timestamps
    end
  end
end
