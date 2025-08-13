require "test_helper"

class FamilyGroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_groups_index_url
    assert_response :success
  end

  test "should get create" do
    get family_groups_create_url
    assert_response :success
  end

  test "should get destroy" do
    get family_groups_destroy_url
    assert_response :success
  end
end
