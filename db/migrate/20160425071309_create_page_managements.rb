class CreatePageManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :page_managements do |t|
      t.integer :user_id
      t.integer :page_id
    end
  end
end
