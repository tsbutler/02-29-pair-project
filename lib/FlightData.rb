require 'date'

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

def response_key_value_data
  HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV["GOOGLE_FLIGHT_API_KEY"]}",
    { 
    :body => request_data.to_json,
    :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  })
end

MyApp.get "/users/:id/process_search" do
  @locations_and_prices = {}
  @current_user = User.find_by_id(session["user_id"])
  @airport_codes = @current_user.get_airport_codes(@current_user.id)
  @airport_codes.each do |code|
    request_data(code) 
    @locations_and_prices[code] = response_key_value_data["trips"]["tripOption"][0]["saleTotal"]
  end

  @gtfo_string_arr = @current_user.get_price_array(@current_user.id, @locations_and_prices)

  @returnable_location_and_price_hash = @current_user.get_codes_and_prices(@current_user.id, @locations_and_prices)

  @returnable_location_and_price_array = @returnable_location_and_price_hash.to_a

  @return_this = []
  @returnable_location_and_price_array.each do |i|
    @return_this << (i[0] + " -- " + i[1])
  end
  
  erb :"users/display_results"
end