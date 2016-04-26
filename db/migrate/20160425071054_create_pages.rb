class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :facebook_id
      t.string :name
      t.string :access_token

      t.timestamps
    end
  end
end
