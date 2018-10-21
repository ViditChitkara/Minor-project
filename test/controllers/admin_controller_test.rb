require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get create_elections" do
    get admin_create_elections_url
    assert_response :success
  end

  test "should get elections" do
    get admin_elections_url
    assert_response :success
  end

end
