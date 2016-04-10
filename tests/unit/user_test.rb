require 'test_helper'

class UserTest < Minitest::Test

  def setup 
    @user_1 = User.new
    @user_1.name = "Billy Bob"
    @user_1.username = "BB2001"
    @user_1.email = "bob@bob.com"
    @user_1.password = "bob"
    @user_1.budget = 2300
    @user_1.save

    @destination_4 = Destination.new
    @destination_4.airport_code = "LHR"
    @destination_4.name = "London Heathrow"
    @destination_4.save

    @choice_1 = Choice.new
    @choice_1.destination_id = @destination_4.id
    @choice_1.user_id = @user_1.id
    @choice_1.save



    @user_2 = User.new
    @user_2.name = ""
    @user_2.username = ""
    @user_2.email = ""
    @user_2.password = ""
    @user_2.budget = nil
    @user_2.save
  end
  
  def test_set_errors_blank_info
    assert_includes(@user_2.set_errors, "Email cannot be blank.")
    assert_includes(@user_2.set_errors, "Password cannot be blank.")
    assert_includes(@user_2.set_errors, "Username cannot be blank.")
    assert_includes(@user_2.set_errors, "Name cannot be blank.")
    assert_includes(@user_2.set_errors, "Budget cannot be blank.")
  end

  def test_set_errors_full_info
    assert_equal(@user_1.set_errors, nil)
  end

  def test_is_valid?
    assert_equal(@user_1.is_valid?, true)
    assert_equal(@user_2.is_valid?, false)
  end

  def test_get_errors
    assert_equal(@user_1.get_errors, [])
    assert_includes(@user_2.get_errors, "Email cannot be blank.")
    assert_includes(@user_2.get_errors, "Password cannot be blank.")
    assert_includes(@user_2.get_errors, "Username cannot be blank.")
    assert_includes(@user_2.get_errors, "Name cannot be blank.")
    assert_includes(@user_2.get_errors, "Budget cannot be blank.")
  end

  def test_get_choices
    assert_includes(@user_1.get_choices, @choice_1)
  end

  def test_get_destination_ids
    assert_includes(@user_1.get_destination_ids, @destination_4.id)
  end

  def test_get_airport_codes
    assert_includes(@user_1.get_airport_codes, "LHR")
  end
end
