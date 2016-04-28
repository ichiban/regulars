class AddReachToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :reach, :integer
  end
end
