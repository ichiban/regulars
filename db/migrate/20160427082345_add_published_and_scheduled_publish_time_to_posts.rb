class AddPublishedAndScheduledPublishTimeToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :published, :boolean
    add_column :posts, :scheduled_publish_time, :datetime
  end
end
