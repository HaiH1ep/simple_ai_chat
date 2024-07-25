require "test_helper"

class LinkedinConnectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @linkedin_connection = linkedin_connections(:one)
  end

  test "should get index" do
    get linkedin_connections_url
    assert_response :success
  end

  test "should get new" do
    get new_linkedin_connection_url
    assert_response :success
  end

  test "should create linkedin_connection" do
    assert_difference("LinkedinConnection.count") do
      post linkedin_connections_url, params: { linkedin_connection: { company: @linkedin_connection.company, connected_on: @linkedin_connection.connected_on, email: @linkedin_connection.email, first_name: @linkedin_connection.first_name, last_name: @linkedin_connection.last_name, position: @linkedin_connection.position, profile_url: @linkedin_connection.profile_url } }
    end

    assert_redirected_to linkedin_connection_url(LinkedinConnection.last)
  end

  test "should show linkedin_connection" do
    get linkedin_connection_url(@linkedin_connection)
    assert_response :success
  end

  test "should get edit" do
    get edit_linkedin_connection_url(@linkedin_connection)
    assert_response :success
  end

  test "should update linkedin_connection" do
    patch linkedin_connection_url(@linkedin_connection), params: { linkedin_connection: { company: @linkedin_connection.company, connected_on: @linkedin_connection.connected_on, email: @linkedin_connection.email, first_name: @linkedin_connection.first_name, last_name: @linkedin_connection.last_name, position: @linkedin_connection.position, profile_url: @linkedin_connection.profile_url } }
    assert_redirected_to linkedin_connection_url(@linkedin_connection)
  end

  test "should destroy linkedin_connection" do
    assert_difference("LinkedinConnection.count", -1) do
      delete linkedin_connection_url(@linkedin_connection)
    end

    assert_redirected_to linkedin_connections_url
  end
end
