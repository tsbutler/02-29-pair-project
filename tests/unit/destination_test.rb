require 'test_helper'

class DestinationTest < Minitest::Test

  def setup
    @destination_1 = Destination.new
    @destination_1.airport_code = ""
    @destination_1.name = "Tokyo"
    @destination_1.save

    @destination_2 = Destination.new
    @destination_2.airport_code = "LHR"
    @destination_2.name = ""
    @destination_2.save

    @destination_3 = Destination.new
    @destination_3.airport_code = "ODB"
    @destination_3.name = "fly"
    @destination_3.save

  end

  def test_set_errors
    assert_includes(@destination_1.set_errors, "Airport code cannot be blank.")
    assert_includes(@destination_2.set_errors, "Name cannot be blank.")
  end

  def test_is_valid?
    assert_equal(@destination_1.is_valid?, false)
    assert_equal(@destination_2.is_valid?, false)
    assert_equal(@destination_3.is_valid?, true)
  end

  def test_get_errors
    assert_equal(@destination_3.get_errors, [])
    assert_includes(@destination_2.get_errors, "Name cannot be blank.")
    assert_includes(@destination_1.get_errors, "Airport code cannot be blank.")
  end


end