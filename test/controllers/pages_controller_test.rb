require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test '#show: my page' do
    user = users(:yutaka)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    get :show, id: page.id
    assert_response :success
    assert_equal :dashboard, @controller.current_tab
  end

  test '#show: others page' do
    user = users(:terry)
    page = pages(:hair_salon_yutaka)
    @controller.current_user = user
    get :show, id: page.id
    assert_response :unauthorized
  end
end
