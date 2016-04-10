require 'date'

#Sets the request_data variable. Requires the input of an aiport code string.
def request_data(code)
   request_data = {
      "request" => {
        "passengers" => {
          "adultCount" => "1"
        },
        "slice" => [
          {
            "origin" => "OMA",
            "destination" => code,
            "date" => (Date.today + 1).to_s
          }
        ],
        "solutions" => "1"
      }
    }
end

#Posts the request to the API.
#
#Returns a large Hash of Hashes and Arrays.
def response_key_value_data(code)
    HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV["GOOGLE_FLIGHT_API_KEY"]}",
    { 
    :body => request_data(code).to_json,
    :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  })
end

#Runs a search for flights and prices based on list of user choices.
#
#Returns a Hash of locations and prices.
def process_search(user_id)
  locations_and_prices = {}
  user = User.find_by_id(user_id)
  user.get_airport_codes.each do |code|
    locations_and_prices[code] = response_key_value_data(code)["trips"]["tripOption"][0]["saleTotal"]
  end
  locations_and_prices
end

#Returns listing of the values from the locations_and_prices 
#hash
#
#Returns an Array of Strings
def get_values_from_locations_and_prices_hash(user_id)
  process_search(user_id).values
end

#Removes the "USD" at the beginning of the price Strings
#
#Returns an Array of Strings
def strip_usd_from_the_strings(user_id)
  fares_to_compare = []
  get_values_from_locations_and_prices_hash(user_id).each do |string|
    fares_to_compare << string.delete("USD")
  end
  fares_to_compare
end

#Converts the fares_to_compare Array of Strings into an Array of Floats
#
#Returns an Array of Floats
def convert_strings_to_floats(user_id)
  float_array = []
  strip_usd_from_the_strings(user_id).each do |fare|
    float_array << fare.to_f
  end
  float_array
end

#Returns an Array of fares that are under the user's budget
#
#returns an Array of Floats
def compare_response_to_user_budget(user_id)
  fares_under_budget = []
  convert_strings_to_floats(user_id).each do |fare|
    if fare <= User.find_by_id(user_id).budget
        fares_under_budget << fare
    end
  end
  fares_under_budget
end

#Converts the fares that are under the user's budget back into strings
#
#Returns an Array of Strings
def convert_fares_under_budget_back_to_s(user_id)
  fares_under_budget_string_array = []
  compare_response_to_user_budget(user_id).each do |fare|
    fare = "%.2f" % fare
    fares_under_budget_string_array << fare
  end
  fares_under_budget_string_array
end

#Maps the string "USD" onto the fares that are under the user's budget
#
#Returns an Array of Strings
def mapping_usd_to_fares(user_id)
  convert_fares_under_budget_back_to_s(user_id).map! { |word| "USD#{word}" }
end

#Creates a Hash of airport codes and prices that are under a user's budget
#
#Returns a Hash of Strings and Strings
def create_hash_of_codes_from_prices(user_id)
  codes_and_prices = {}
  mapping_usd_to_fares(user_id).each do |i|
    key = process_search(user_id).key(i)
    codes_and_prices[key] = i
  end
  codes_and_prices
end

#Converts the Hash of results into an array
#
#Returns an Array of Arrays
def converts_result_hash_into_array(user_id)
  create_hash_of_codes_from_prices(user_id).to_a
end

#Final polish before we get to the point of displaying results.
#
#Returns an Array.
def return_this(user_id)
  return_this = []
  converts_result_hash_into_array(user_id).each do |i|
    return_this << (i[0] + " -- " + i[1])
  end
return return_this
end






