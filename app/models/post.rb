class Post < ApplicationRecord
  scope :unpublished, -> { where(published: false, scheduled_publish_time: nil) }
  scope :scheduled, -> { where(published: false).where.not(scheduled_publish_time: nil) }
  scope :published, -> { where(published: true) }

  class << self
    def fields
      @fields ||= %w(message is_published scheduled_publish_time full_picture insights).join(',')
    end
  end

  PRESETS = {
      short: { label: 'Proposal: Short', published: false, offset: 1.month },
      middle: { label: 'Proposal: Middle', published: false, offset: 2.months },
      long: { label: 'Proposal: Long', published: false, offset: 3.months },
      follow_up: { label: 'Follow-up', published: true },
      stock: { label: 'Stock for ads', published: false },
  }

  def preset
    super&.to_sym
  end

  # @param key [String|Symbol]
  def preset=(key)
    key = key.to_sym
    super key
    preset = PRESETS[key]
    self.published = !!preset[:published]
    if preset[:offset]
      base_time = created_at || Time.current
      publish_time = (base_time + preset[:offset]).change(hour: 11, min: 45)
      self.scheduled_publish_time = publish_time
    else
      self.scheduled_publish_time = nil
    end
  end

  attr :photo, true

  belongs_to :page

  validates :message, length: { maximum: 63206 }

  # @param result [nil|Hash]
  def pull(result = nil)
    raise ArgumentError.new('this hash is not for the post') if result && facebook_id != result['id']
    result ||= graph.get_object(facebook_id, fields: self.class.fields)
    self.message = result['message']
    self.published = result['is_published']
    self.scheduled_publish_time = Time.at(result['scheduled_publish_time']).to_datetime if result['scheduled_publish_time']
    self.full_picture = result['full_picture']
    self.reach = result
                     .dig('insights', 'data')
                     .select {|d| 'post_impressions_unique' == d['name'] }
                     .dig(0, 'values', 0, 'value')
  end

  def push
    if facebook_id
      graph.graph_call facebook_id, to_fb_hash, 'POST'
    else
      if photo
        result = graph.graph_call "#{page.facebook_id}/photos", to_fb_hash, 'POST'
        if result['post_id']
          self.facebook_id = result['post_id']
        else
          # if the photo is unpublished, it won't return post_id.
          # http://stackoverflow.com/questions/35018755/how-to-create-and-edit-unpublished-facebook-post-with-image
          self.facebook_id = "#{page.facebook_id}_#{result['id']}"
        end
      else
        result = graph.graph_call "#{page.facebook_id}/feed", to_fb_hash, 'POST'
        self.facebook_id = result['id']
      end
    end
  end

  def scope
    if published?
      :published
    else
      if scheduled_publish_time
        :scheduled
      else
        :unpublished
      end
    end
  end

  private

  def to_fb_hash
    {
        message: message,
        published: published?,
        scheduled_publish_time: scheduled_publish_time&.to_time&.to_i,
        source: photo && Koala::UploadableIO.new(photo),
    }
  end

  # @return [Koala::Facebook::API]
  def graph
    page.graph if page
  end
end
