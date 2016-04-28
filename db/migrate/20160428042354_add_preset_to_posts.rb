class AddPresetToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :preset, :string
  end
end
