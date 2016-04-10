#columns: "name", "username", "email", "password", "budget"
class User < ActiveRecord::Base
  include Errors
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

  #gets the user_object based on a given user id
  #
  #Returns the user_object
  def self.get_user_object(user_id)
    @user = User.find_by_id(user_id)
  end
  #Returns a collection of the user's choice objects
  #
  #Returns an Array of Objects
  def get_choices
    @choices = Choice.where("user_id" => self.id)
  end

  #Returns an Array of destination IDs associated with the user's choices
  #
  #Returns an Array of Integers
  def get_destination_ids
    destination_ids = []
    get_choices.each do |choice|
      destination_ids << choice.destination_id
    end
    destination_ids
  end

  #Returns an Array of airport_codes associated with the user's choices
  #
  #Returns an Array of Strings
  def get_airport_codes
    airport_codes = []
    get_destination_ids.each do |destination|
      location = Destination.find_by_id(destination)
      airport_codes << location.airport_code
    end
    return airport_codes
  end

  #Saves user's choices when they update their profile
  #
  #Saves data to the database
  def save_choice_objects(user_choices)
    choices = user_choices
    choices.each do |choice|
      @choice = Choice.new
      @choice.user_id = self.id
      @choice.destination_id = choice
      @choice.save
    end
  end

  #Deletes user's choices when they fail to completely fill out the form
  #
  #Deletes items from the database.
  def delete_users_choices
    choices = get_choices
    choices.each do |choice|
      choice.delete
    end
  end

end

