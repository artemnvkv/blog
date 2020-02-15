class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :rating, null: false, default: 0
      t.integer :sum_ratings, null: false, default: 0
      t.integer :num_ratings, null: false, default: 0

      t.timestamps
    end

    add_index(:posts, :rating, order: { rating: :desc })
  end
end
