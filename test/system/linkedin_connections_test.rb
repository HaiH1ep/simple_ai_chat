require "application_system_test_case"

class LinkedinConnectionsTest < ApplicationSystemTestCase
  setup do
    @linkedin_connection = linkedin_connections(:one)
  end

  test "visiting the index" do
    visit linkedin_connections_url
    assert_selector "h1", text: "Linkedin connections"
  end

  test "should create linkedin connection" do
    visit linkedin_connections_url
    click_on "New linkedin connection"

    fill_in "Company", with: @linkedin_connection.company
    fill_in "Connected on", with: @linkedin_connection.connected_on
    fill_in "Email", with: @linkedin_connection.email
    fill_in "First name", with: @linkedin_connection.first_name
    fill_in "Last name", with: @linkedin_connection.last_name
    fill_in "Position", with: @linkedin_connection.position
    fill_in "Profile url", with: @linkedin_connection.profile_url
    click_on "Create Linkedin connection"

    assert_text "Linkedin connection was successfully created"
    click_on "Back"
  end

  test "should update Linkedin connection" do
    visit linkedin_connection_url(@linkedin_connection)
    click_on "Edit this linkedin connection", match: :first

    fill_in "Company", with: @linkedin_connection.company
    fill_in "Connected on", with: @linkedin_connection.connected_on
    fill_in "Email", with: @linkedin_connection.email
    fill_in "First name", with: @linkedin_connection.first_name
    fill_in "Last name", with: @linkedin_connection.last_name
    fill_in "Position", with: @linkedin_connection.position
    fill_in "Profile url", with: @linkedin_connection.profile_url
    click_on "Update Linkedin connection"

    assert_text "Linkedin connection was successfully updated"
    click_on "Back"
  end

  test "should destroy Linkedin connection" do
    visit linkedin_connection_url(@linkedin_connection)
    click_on "Destroy this linkedin connection", match: :first

    assert_text "Linkedin connection was successfully destroyed"
  end
end
