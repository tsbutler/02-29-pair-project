class Destination < ActiveRecord::Base
  include Errors
  
  #generates an Array of input errors
  #
  #returns Array of Strings
  def set_errors
    @errors = []

    if self.name == nil || self.name == ""
      @errors << "Name cannot be blank."
    end
    if self.airport_code == nil || self.airport_code == ""
      @errors << "Airport code cannot be blank."
    end
    return @errors
  end

end