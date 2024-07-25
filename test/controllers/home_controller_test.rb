require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get health" do
    get rails_health_check_url
    binding.pry
    assert_response :success
  end
end
