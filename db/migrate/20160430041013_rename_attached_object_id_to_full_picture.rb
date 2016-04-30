class RenameAttachedObjectIdToFullPicture < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :attached_object_id, :full_picture
  end
end
