require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test '#new: not logged in' do
    get :new
    assert_response :success
  end

  test '#new: logged in without a page' do
    user = users(:terry)
    assert_empty user.pages
    @controller.current_user = user
    get :new
    assert_redirected_to new_page_path
  end

  test '#new: logged in with a page' do
    user = users(:yutaka)
    page = user.pages.first
    assert_not_nil page
    @controller.current_user = user
    get :new
    assert_redirected_to page_path(page)
  end

  test '#create: new user' do
    page = pages(:hair_salon_yutaka)
    User.stub_any_instance(:pull, nil) do
      User.stub_any_instance(:pages, [page]) do
        assert_difference -> { User.count }, 1 do
          post :create, user: { facebook_id: 'new facebook id', access_token: 'unknown access token' }
        end
        assert_not_nil @controller.current_user
      end
    end
  end

  test '#create: existing user' do
    user = users(:yutaka)
    User.stub_any_instance(:pull, nil) do
      assert_no_difference -> { User.count } do
        post :create, user: { facebook_id: user.facebook_id, access_token: user.access_token }
      end
      assert_equal user, @controller.current_user
    end
  end

  test '#destroy: me' do
    user = users(:yutaka)
    @controller.current_user = user
    delete :destroy, id: user.id
    assert_response :success
    assert_empty session
  end

  test '#destroy: someone else' do
    me = users(:yutaka)
    other = users(:terry)
    @controller.current_user = me
    delete :destroy, id: other.id
    assert_response :unauthorized
  end
end
