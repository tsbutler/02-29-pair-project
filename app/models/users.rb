class User < ActiveRecord::Base

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