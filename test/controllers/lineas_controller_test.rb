require "test_helper"

class LineasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lineas_index_url
    assert_response :success
  end

  test "should get new" do
    get lineas_new_url
    assert_response :success
  end

  test "should get create" do
    get lineas_create_url
    assert_response :success
  end

  test "should get edit" do
    get lineas_edit_url
    assert_response :success
  end

  test "should get update" do
    get lineas_update_url
    assert_response :success
  end

  test "should get destroy" do
    get lineas_destroy_url
    assert_response :success
  end
end
