class Choice < ActiveRecord::Base

  def set_errors
    @errors = []
    
    if self.destination_id == nil || self.destination_id == ""
      @errors << "Destination cannot be blank."
    end
  
  end

  def is_valid?
    self.set_errors

    if @errors.length > 0
      return false
    else
      return true
    end
  end

  def get_errors
    return @errors
  end
end