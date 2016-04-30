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

  def photos_url
    "https://#{Koala.config.graph_server}/#{Koala.config.api_version}/#{facebook_id}/photos"
  end

  private

  def page_posts
    graph.get_connection('me', 'promotable_posts', fields: Post.fields)
  end
end
