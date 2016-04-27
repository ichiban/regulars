class Page < ApplicationRecord
  has_many :page_managements
  has_many :users, through: :page_managements
  has_many :posts

  validates :facebook_id, presence: true, uniqueness: true

  before_create :pull!

  def pull!
    logger.debug 'Page#pull!'
    fb_ids = page_posts.map {|p| p['id'] }
    existing_posts = {}
    Post.where(facebook_id: fb_ids).each do |p|
      existing_posts[p.facebook_id] = p
    end
    pp page_posts
    self.posts = page_posts.map do |page_post|
      post = existing_posts[page_post['id']] || Post.new(facebook_id: page_post['id'])
      post.message = page_post['message']
      post.created_at = page_post['created_time']
      post
    end
    pp posts
  end

  def graph
    @graph ||= Koala::Facebook::API.new(access_token)
  end

  private

  def page_posts
    graph.get_connection('me', 'posts', include_hidden: true)
  end
end
