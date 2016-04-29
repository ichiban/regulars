require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test '#preset=:short' do
    post = posts(:new_proposal_of_perm)
    post.preset = :short
    assert_equal :short, post.preset
    assert_equal false, post.published?
    assert_not_nil post.scheduled_publish_time
  end

  test '#preset=:follow_up' do
    post = posts(:new_proposal_of_perm)
    post.preset = :follow_up
    assert_equal :follow_up, post.preset
    assert_equal true, post.published?
    assert_nil post.scheduled_publish_time
  end

  test '#preset=:stock' do
    post = posts(:new_proposal_of_perm)
    post.preset = :stock
    assert_equal :stock, post.preset
    assert_equal false, post.published?
    assert_nil post.scheduled_publish_time
  end

  test '#scope' do
    post = Post.published.first
    assert_not_nil post
    assert_equal :published, post.scope
    post = Post.scheduled.first
    assert_not_nil post
    assert_equal :scheduled, post.scope
    post = Post.unpublished.first
    assert_not_nil post
    assert_equal :unpublished, post.scope
  end
end
