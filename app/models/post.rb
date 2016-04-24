class Post < ApplicationRecord
  validates :message, presence: true, length: { in: 0..63206 }
end
