require 'test_helper'

class ChoiceTest < Minitest::Test

  def setup
    @user_1 = User.new
    @user_1.save

    @user_2 = User.new
    @user_2.save

    @choice_1 = Choice.new
    @choice_1.destination_id = 1
    @choice_1.user_id = @user_1.id
    @choice_1.save

    @choice_2 = Choice.new
    @choice_2.destination_id = nil
    @choice_2.user_id = @user_2.id
    @choice_2.save
  end

  def test_set_errors
    assert_includes(@choice_2.set_errors, "Destination cannot be blank.")
    assert_equal(@choice_1.set_errors, nil)
  end

  def test_is_valid?
    assert_equal(@choice_1.is_valid?, true)
    assert_equal(@choice_2.is_valid?, false)
  end

  def test_get_errors
    assert_includes(@choice_2.get_errors, "Destination cannot be blank.")
    assert_equal(@choice_1.get_errors, [])
  end

end