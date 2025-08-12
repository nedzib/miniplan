require "test_helper"

class RsvpControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm" do
    get rsvp_confirm_url
    assert_response :success
  end
end
