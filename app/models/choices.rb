class Choice < ActiveRecord::Base
  include Errors

  #generates an Array of input errors
  #
  #returns Array of Strings
  def set_errors
    @errors = []
    
    if self.destination_id == nil || self.destination_id == ""
      @errors << "Destination cannot be blank."
    end
  
  end
end