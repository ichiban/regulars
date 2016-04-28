class Page < ApplicationRecord
  has_many :page_managements
  has_many :users, through: :page_managements
  has_many :posts, autosave: true

  validates :facebook_id, presence: true, uniqueness: true

  def pull
    # cache existing posts in one SQL query
    fb_ids = page_posts.map {|p| p['id'] }
    existing_posts = {}
    Post.where(facebook_id: fb_ids).each do |p|
      existing_posts[p.facebook_id] = p
    end

    self.posts = page_posts.map do |page_post|
      post = existing_posts[page_post['id']] || self.posts.new(facebook_id: page_post['id'])
      post.pull page_post
      post
    end
  end

  def graph
    Koala::Facebook::API.new(access_token)
  end

  private

  def page_posts
    results = []
    posts = graph.get_connection('me', 'promotable_posts')
    posts.each_slice(25) do |slice|
      result = graph.batch do |batch|
        slice.each do |post|
          batch.get_object(post['id'], fields: Post.fields)
          batch.get_connection(post['id'], 'insights/post_impressions_unique/lifetime')
        end
      end
      results << result.each_slice(2).map do |post, insights|
        post['insights'] = insights
        post
      end
    end
    results.flatten
  end
end
