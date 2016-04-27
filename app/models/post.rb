class Post < ApplicationRecord
  PRESETS = {
      follow_up: 'Follow-up',
      short: 'Proposal: Short',
      middle: 'Proposal: Middle',
      long: 'Proposal: Long',
      stock: 'Stock for ads',
  }

  attr :preset, true

  belongs_to :page

  validates :message, presence: true, length: { maximum: 63206 }

  def pull
    logger.debug 'Post#pull'
  end

  def push
    logger.debug 'Post#push'
    if facebook_id
      graph.graph_call facebook_id, to_fb_hash, 'POST'
    else
      result = graph.graph_call "#{facebook_id}/feed", to_fb_hash, 'POST'
      self.facebook_id = result['id']
    end
  end

  private

  def to_fb_hash
    {
        message: message
    }
  end

  def insights

  end

  # @return [Koala::Facebook::API]
  def graph
    page.graph if page
  end
end
