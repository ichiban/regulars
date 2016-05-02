class Page < ApplicationRecord
  has_many :page_managements
  has_many :users, through: :page_managements
  has_many :posts, autosave: true

  validates :facebook_id, presence: true, uniqueness: true

  def pull
    # cache existing posts in one SQL query
    posts = page_posts
    fb_ids = posts.map {|p| p['id'] }
    existing_posts = {}
    Post.where(facebook_id: fb_ids).each do |p|
      existing_posts[p.facebook_id] = p
    end

    self.posts = posts.map do |page_post|
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

  def chart
    @chart ||= begin
      window = 1.month.ago..5.months.from_now
      weeks = window.begin.strftime('%U').to_i..window.end.strftime('%U').to_i
      projected = posts
                      .where(scheduled_publish_time: window)
                      .group('WEEK(scheduled_publish_time)')
                      .count(:scheduled_publish_time)
      actual = posts
                   .where(created_at: window)
                   .where.not(preset: nil)
                   .group('WEEK(created_at)')
                   .count(:created_at)
      projected_series = weeks.map {|d| projected[d] || 0 }
      actual_series = weeks.map {|d| actual[d] || 0 }
      {
          labels: weeks.map do |w|
            if 0 == w % 4
              week = w.weeks.since(Time.current.beginning_of_year)
              I18n.l(week.beginning_of_week.to_date, format: :short)
            else
              nil
            end
          end.to_a,
          series: [projected_series, actual_series]
      }
    end
  end

  private

  def page_posts
    graph.get_connection('me', 'promotable_posts', fields: Post.fields)
  end
end
