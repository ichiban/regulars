require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test '#preset=:short' do
    post = posts(:proposal_for_yutaka)
    post.preset = :short
    assert_equal :short, post.preset
    assert_equal false, post.published?
    assert_not_nil post.scheduled_publish_time
  end

  test '#preset=:follow_up' do
    post = posts(:proposal_for_yutaka)
    post.preset = :follow_up
    assert_equal :follow_up, post.preset
    assert_equal true, post.published?
    assert_nil post.scheduled_publish_time
  end

  test '#preset=:stock' do
    post = posts(:proposal_for_yutaka)
    post.preset = :stock
    assert_equal :stock, post.preset
    assert_equal false, post.published?
    assert_nil post.scheduled_publish_time
  end
end
