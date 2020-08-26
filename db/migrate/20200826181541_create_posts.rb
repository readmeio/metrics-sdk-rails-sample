class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, index: true, null: false

      t.text :body, null: false
      t.string :title

      t.timestamps null: false
    end
  end
end
