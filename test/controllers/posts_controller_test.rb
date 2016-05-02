require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test '#index: my page' do
    user = users(:yutaka)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    Page.stub_any_instance :pull, nil do
      get :index, page_id: page.id
    end
    assert_response :success
  end

  test '#index: others page' do
    user = users(:terry)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    Page.stub_any_instance :pull, nil do
      get :index, page_id: page.id
    end
    assert_response :unauthorized
  end

  test '#new: my page' do
    user = users(:yutaka)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    get :new, page_id: page.id
    assert_response :success
  end

  test '#new: others page' do
    user = users(:terry)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    get :new, page_id: page.id
    assert_response :unauthorized
  end

  test '#edit: my page' do
    user = users(:yutaka)
    post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    get :edit, page_id: post.page.id, id: post.id
    assert_response :success
  end

  test '#edit: others page' do
    user = users(:terry)
    post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    get :new, page_id: post.page.id, id: post.id
    assert_response :unauthorized
  end

  test '#create: my page' do
    user = users(:yutaka)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    Post.stub_any_instance :push, nil do
      Post.stub_any_instance :pull, nil do
        post :create, page_id: page.id, post: { message: 'new proposal', preset: :short }
      end
    end
    assert_response :success
  end

  test '#create: others page' do
    user = users(:terry)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    post :create, page_id: page.id, post: { message: 'new proposal', preset: :short }
    assert_response :unauthorized
  end

  test '#update: my page' do
    user = users(:yutaka)
    a_post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    Post.stub_any_instance :push, nil do
      Post.stub_any_instance :pull, nil do
        post :create, page_id: a_post.page.id, id: a_post.id, post: { message: 'new proposal', preset: :short }
      end
    end
    assert_response :success
  end

  test '#update: others page' do
    user = users(:terry)
    a_post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    post :create, page_id: a_post.page.id, id: a_post.id, post: { message: 'new proposal', preset: :short }
    assert_response :unauthorized
  end

  test '#destroy: my page' do
    user = users(:yutaka)
    a_post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    Post.stub_any_instance :delete_on_fb, nil do
      delete :destroy, page_id: a_post.page.id, id: a_post.id
    end
    assert_response :success
  end

  test '#destroy: others page' do
    user = users(:terry)
    a_post = posts(:proposal_for_yutaka_this_month)
    @controller.current_user = user
    delete :destroy, page_id: a_post.page.id, id: a_post.id
    assert_response :unauthorized
  end
end
