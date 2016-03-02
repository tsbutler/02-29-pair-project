require 'test_helper'

class DestinationTest < Minitest::Test

  def setup
    @d1 = Destination.new
    @d1.airport_code = ""
    @d1.name = "Tokyo"
    @d1.save

    @d2 = Destination.new
    @d2.airport_code = "LHR"
    @d2.name = ""
    @d2.save

    @d3 = Destination.new
    @d3.airport_code = "ODB"
    @d3.name = "fly"
    @d3.save

  end

  def test_set_errors
    assert_includes(@d1.set_errors, "Airport code cannot be blank.")
    assert_includes(@d2.set_errors, "Name cannot be blank.")
  end

  def test_is_valid?
    assert_equal(@d1.is_valid?, false)
    assert_equal(@d2.is_valid?, false)
    assert_equal(@d3.is_valid?, true)
  end

  def test_get_errors
    assert_equal(@d3.get_errors, [])
    assert_includes(@d2.get_errors, "Name cannot be blank.")
    assert_includes(@d1.get_errors, "Airport code cannot be blank.")
  end


end