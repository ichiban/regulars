class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :page_id
      t.string :state
      t.string :facebook_id
      t.text :message

      t.timestamps
    end
  end
end
