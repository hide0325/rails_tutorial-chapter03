require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation .alert', "The form contains 4 errors."
    assert_select 'div#error_explanation ul li:first-child', "Name can't be blank"
    assert_select 'div#error_explanation ul li:nth-child(2)', "Email is invalid"
    assert_select 'div#error_explanation ul li:nth-child(3)', "Password confirmation doesn't match Password"
    assert_select 'div#error_explanation ul li:nth-child(4)', "Password is too short (minimum is 6 characters)"
    assert_select 'form[action="/signup"]'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end