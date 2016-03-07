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

  #Returns a collection of the user's choice objects
  #
  #Returns an Array of Objects
  def get_choices(user_id)
    @choices = Choice.where("user_id" => user_id)
    return @choices
  end

  #Returns an Array of destination IDs associated with the user's choices
  #
  #Returns an Array of Integers
  def get_destination_ids(user_id)
    @destination_ids = []
    @user_object = User.find_by_id(user_id)
    @choices = @user_object.get_choices(user_id)
    @choices.each do |choice|
      @destination_ids << choice.destination_id
    end
    return @destination_ids
  end

  #Returns an Array of airport_codes associated with the user's choices
  #
  #Returns an Array of Strings
  def get_airport_codes(user_id)
    @airport_codes = []
    @user_object = User.find_by_id(user_id)
    @destinations = @user_object.get_destination_ids(user_id)
    @destinations.each do |destination|
      location = Destination.find_by_id(destination)
      @airport_codes << location.airport_code
    end
    return @airport_codes
  end

  #Generates an Array of prices drawn from the locations_and_prices Hash.
  #
  #Returns an Array of Strings
  def set_price_arr(locations_and_prices)
    @price_arr = locations_and_prices.values
    return @price_arr
  end

  #Takes an Array of Strings(prices) and converts them to an Array of Floats
  #(still prices)
  #
  #Returns an Array of Floats  
  def convert_price_arr_to_floats(set_price_arr)
    @gtfo_arr = []
    price_arr.each do |string_price|
      price = string_price.delete("USD").to_f
        @gtfo_arr << price
    end
  end

  #Compares an Array of Floats to the user's stated budget.
  #
  #Returns an Array of Floats.
  def compare_price_arr_to_budget(gtfo_arr)
    @passing_arr = []
    gtfo_arr.each do |price|
      if price <= @user.budget
        @passing_arr << price
      end
    end
    return @passing_arr
  end
  
  def converts_passing_arr_back_to_strings(passing_arr)
    @gtfo_string_arr = []
    @passing_arr.each do |i|
      i = "%.2f" % i
      @gtfo_string_arr << i
    end
  end

  def map_usd_onto_gtfo_string_arr
    @gtfo_string_arr.map! { |word| "USD#{word}" }
    return @gtfo_string_arr
  end

  

  #Returns a Hash of the airports codes and prices that are below the users #stated budget, with airport codes as Keys and prices as Values
  #
  #Returns a Hash of Strings
  def get_codes_and_prices(user_id, locations_and_prices)
    @codes_and_prices = {}
    @user = User.find_by_id(user_id)
    @gtfo_string_arr = @user.get_price_array(user_id, locations_and_prices)
 
    @gtfo_string_arr.each do |i|
      gtfo_key = locations_and_prices.key(i)
      @codes_and_prices[gtfo_key] = i
    end
    return @codes_and_prices #hash of keys(codes) and values(prices) below budget
  end

end