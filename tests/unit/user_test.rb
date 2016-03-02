require 'test_helper'

class UserTest < Minitest::Test

  def setup 
    @u1 = User.new
    @u1.name = "Billy Bob"
    @u1.username = "BB2001"
    @u1.email = "bob@bob.com"
    @u1.password = "bob"
    @u1.budget = 2300
    @u1.save

    @u2 = User.new
    @u2.name = ""
    @u2.username = ""
    @u2.email = ""
    @u2.password = ""
    @u2.budget = nil
    @u2.save
  end
  
  def test_set_errors_blank_info
    assert_includes(@u2.set_errors, "Email cannot be blank.")
    assert_includes(@u2.set_errors, "Password cannot be blank.")
    assert_includes(@u2.set_errors, "Username cannot be blank.")
    assert_includes(@u2.set_errors, "Name cannot be blank.")
    assert_includes(@u2.set_errors, "Budget cannot be blank.")
  end

  def test_set_errors_full_info
    assert_equal(@u1.set_errors, nil)
  end

  def test_is_valid?
    assert_equal(@u1.is_valid?, true)
    assert_equal(@u2.is_valid?, false)
  end

  def test_get_errors
    assert_equal(@u1.get_errors, [])
    assert_includes(@u2.get_errors, "Email cannot be blank.")
    assert_includes(@u2.get_errors, "Password cannot be blank.")
    assert_includes(@u2.get_errors, "Username cannot be blank.")
    assert_includes(@u2.get_errors, "Name cannot be blank.")
    assert_includes(@u2.get_errors, "Budget cannot be blank.")
  end

end