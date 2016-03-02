require 'test_helper'

class ChoiceTest < Minitest::Test

  def setup
    @u1 = User.new
    @u1.save

    @u2 = User.new
    @u2.save

    @c1 = Choice.new
    @c1.destination_id = 1
    @c1.user_id = @u1.id
    @c1.save

    @c2 = Choice.new
    @c2.destination_id = nil
    @c2.user_id = @u2.id
    @c2.save
  end

  def test_set_errors
    assert_includes(@c2.set_errors, "Destination cannot be blank.")
    assert_equal(@c1.set_errors, nil)
  end

  def test_is_valid?
    assert_equal(@c1.is_valid?, true)
    assert_equal(@c2.is_valid?, false)
  end

  def test_get_errors
    assert_includes(@c2.get_errors, "Destination cannot be blank.")
    assert_equal(@c1.get_errors, [])
  end

end