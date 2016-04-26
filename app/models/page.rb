class Page < ApplicationRecord
  has_many :page_managements
  has_many :users, through: :page_managements
  has_many :posts

  validates :facebook_id, presence: true, uniqueness: true

  before_create :pull!

  def pull!
    self.posts = page_posts.map do |page_post|
      post = Post.where(facebook_id: page_post['id']).first_or_initialize
      post.message = page_post['message']
      post.created_at = page_post['created_time']
      post
    end
  end

  def graph
    @graph ||= Koala::Facebook::API.new(access_token)
  end

  private

  def page_posts
    graph.get_connection('me', 'posts', include_hidden: true)
  end
end
