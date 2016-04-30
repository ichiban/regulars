class AddAttachedObjectIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :attached_object_id, :string
  end
end
