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

  validates :facebook_id, uniqueness: true
  validates :message, presence: true, length: { maximum: 63206 }
  validates :state, presence: true

  after_initialize do
    self.state ||= :duplicate
  end

  before_save :sync

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
      validates :facebook_id, presence: true
    end
  end

  def pull!
    logger.debug "post pull!"

  end

  def push!
    logger.debug "post push!"
  end

  private

  def insights

  end

  def graph
    page.graph if page
  end
end
