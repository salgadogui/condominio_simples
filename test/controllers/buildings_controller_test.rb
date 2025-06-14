require "test_helper"

class BuildingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @building = buildings(:one)
  end

  test "should get index" do
    get buildings_url
    assert_response :success
  end

  test "should get new" do
    get new_building_url
    assert_response :success
  end

  test "should create building" do
    assert_difference("Building.count") do
      post buildings_url, params: { building: { address_city: @building.address_city, address_district: @building.address_district, address_number: @building.address_number, address_street: @building.address_street, cep: @building.cep, name: @building.name, user_id: @building.user_id } }
    end

    assert_redirected_to building_url(Building.last)
  end

  test "should show building" do
    get building_url(@building)
    assert_response :success
  end

  test "should get edit" do
    get edit_building_url(@building)
    assert_response :success
  end

  test "should update building" do
    patch building_url(@building), params: { building: { address_city: @building.address_city, address_district: @building.address_district, address_number: @building.address_number, address_street: @building.address_street, cep: @building.cep, name: @building.name, user_id: @building.user_id } }
    assert_redirected_to building_url(@building)
  end

  test "should destroy building" do
    assert_difference("Building.count", -1) do
      delete building_url(@building)
    end

    assert_redirected_to buildings_url
  end
end
