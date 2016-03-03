class User < ActiveRecord::Base

  #generates an Array of input errors
  #
  #returns Array of Strings
  def set_errors
    @errors = []

    if self.name == nil || self.name == ""
      @errors << "Name cannot be blank."
    end
    if self.username == nil || self.username == ""
      @errors << "Username cannot be blank."
    end
    if self.email == nil || self.email == ""
      @errors << "Email cannot be blank."
    end
    if self.password == nil || self.password == ""
      @errors << "Password cannot be blank."
    end
    if self.budget == nil || self.budget == ""
      @errors << "Budget cannot be blank."
    end
  end

  #tells user whether input to form is valid
  #
  #returns Boolean true or false
  def is_valid?
    self.set_errors

    if @errors.length > 0
      return false
    else
      return true
    end
  end

  #returns Array generated by set_errors method
  #
  #returns @errors Array of Strings
  def get_errors
    self.set_errors
    return @errors
  end

  #returns the list of user choices as airport codes
  #
  #returns Array of Strings
  def get_airport_codes(user_id)
    @destination_ids = []
    @airport_codes = []
    @choices = Choice.where("user_id" => user_id)
    @choices.each do |choice|
      @destination_ids << choice.destination_id
    end
    @destination_ids.each do |destination|
      location = Destination.find_by_id(destination)
      @airport_codes << location.airport_code
    end
    return @airport_codes
  end     

end