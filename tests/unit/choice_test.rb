require 'test_helper'

class ChoiceTest < Minitest::Test

  def setup
    @user_object_for_tests_1 = User.new
    @user_object_for_tests_1.save

    @user_object_for_tests_2 = User.new
    @user_object_for_tests_2.save

    @user_choice_1 = Choice.new
    @user_choice_1.destination_id = 1
    @user_choice_1.user_id = @user_1.id
    @user_choice_1.save

    @user_choice_2 = Choice.new
    @user_choice_2.destination_id = nil
    @user_choice_2.user_id = @user_2.id
    @user_choice_2.save
  end

  def test_set_errors
    assert_includes(@user_choice_2.set_errors, "Destination cannot be blank.")
    assert_equal(@user_choice_1.set_errors, nil)
  end

  def test_is_valid?
    assert_equal(@user_choice_1.is_valid?, true)
    assert_equal(@user_choice_2.is_valid?, false)
  end

  def test_get_errors
    assert_includes(@user_choice_2.get_errors, "Destination cannot be blank.")
    assert_equal(@user_choice_1.get_errors, [])
  end

end