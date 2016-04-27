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
  validates :state, presence: true

  before_validation :sync

  # Since we'll have 2 copies of a same post on our end and FB,
  # we'll use states to handle which one is the newer.
  state_machine :state, initial: :duplicate do
    before_transition :original => :duplicate, do: :push!
    before_transition :duplicate => :duplicate, do: :pull!

    event :sync do
      transition [:original, :duplicate] => :duplicate
    end

    # When it's original, our copy is the newer.
    # It's because we've just created a new post or updated an existing one.
    state :original do

    end

    # When it's duplicate, the one on FB is the newer.
    state :duplicate do
      validates :facebook_id, presence: true, uniqueness: true
    end
  end

  def pull!
    logger.debug "post pull!"
  end

  def push!
    if facebook_id
      graph.graph_call facebook_id, { message: message }, 'POST'
    else
      result = graph.put_wall_post message
      self.facebook_id = result['id']
    end
  end

  private

  def insights

  end

  # @return [Koala::Facebook::API]
  def graph
    page.graph if page
  end
end
