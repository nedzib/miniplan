require "test_helper"

class PresupuestosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get presupuestos_index_url
    assert_response :success
  end

  test "should get show" do
    get presupuestos_show_url
    assert_response :success
  end

  test "should get new" do
    get presupuestos_new_url
    assert_response :success
  end

  test "should get create" do
    get presupuestos_create_url
    assert_response :success
  end

  test "should get edit" do
    get presupuestos_edit_url
    assert_response :success
  end

  test "should get update" do
    get presupuestos_update_url
    assert_response :success
  end

  test "should get destroy" do
    get presupuestos_destroy_url
    assert_response :success
  end
end
