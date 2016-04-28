class RemoveStateFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :state, :string
  end
end
