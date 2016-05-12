require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User",email:"user@example.com",
                    password:"foorabc",password_confirmation:"foorabc")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should not be too long "do
    @user.email = "a" * 244+ "@emxaple.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid address" do
    valid_addresses = %w[user@emample.com USE@foo.COM A_US-ER@foo.bar.org
                        first.last@goo.jp alic+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?,"#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject unvalided address" do
    unvalided_addresses = ["h. @gmail.cm","#!!@gmail.com","abc#$$"]
    unvalided_addresses.each do |unvalid_address|
      @user.email = unvalid_address
      assert_not @user.valid?, "#{unvalid_address.inspect} should be unvalid"
    end
  end

  test "email address should be unique(ignore case)"  do
    duplicate_user = @user.dup
    @user.save
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = "  " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end

  test "authenticated? should return flase for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
