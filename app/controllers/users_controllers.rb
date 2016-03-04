require 'date'
MyApp.get "/users" do
  @users = User.all
  erb :"users/index"
end

MyApp.get "/users/new" do
  @destinations = Destination.all
  erb :"users/new"
end

MyApp.post "/users/create" do
  @user = User.new
  @user.name = params[:name]
  @user.username = params[:username]
  @user.password = params[:password]
  @user.email = params[:email]
  @user.budget = params[:budget]

  if @user.is_valid? == false
    halt erb :"users/error"
  else
    @user.save
  end

  choices = [params["destination_id_1"], params["destination_id_2"], params["destination_id_3"], params["destination_id_4"], params["destination_id_5"]]

  choices.each do |choice|
    @choice = Choice.new
    @choice.user_id = @user.id
    @choice.destination_id = choice

    if @choice.is_valid? == false
      @choices = Choice.where("user_id" => @user.id)
      @choices.each do |choice|
        choice.delete
      end
      @user.delete
      halt erb :"choices/error"
    else
      @choice.save
    end
  end

  redirect "/logins/new"
end

MyApp.get "/users/:id/profile" do
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => params[:id])
  @destinations = Destination.all
  erb :"users/profile"
end

MyApp.get "/users/:id/edit" do
  @destinations = Destination.all
  @dest_id_array = []
  @choices = Choice.where("user_id" => params[:id])
  @choices.each do |c|
    @dest_id_array << c.destination_id
  end
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => @user.id)
  erb :"users/edit"
end

MyApp.post "/users/:id/update" do
  @destinations = Destination.all

  @user = User.find_by_id(params[:id])
  @user.name = params[:name]
  @user.username = params[:username]
  @user.password = params[:password]
  @user.email = params[:email]
  @user.budget = params[:budget]

  if @user.is_valid? == false
    halt erb :"users/error"
  else
    @user.save
  end

  choices = [params["destination_id_1"], params["destination_id_2"], params["destination_id_3"], params["destination_id_4"], params["destination_id_5"]]  
  if choices.include?(nil) || choices.include?("")
    halt erb :"choices/error"
  else
    @choices = Choice.where("user_id" => params[:id])
    @choices.each do |choice|
      choice.delete
    end
  end

  choices.each do |choice|
    @choice = Choice.new
    @choice.user_id = @user.id
    @choice.destination_id = choice
    @choice.save
  end

  redirect "/users/#{@user.id}/profile"
end

MyApp.post "/users/:id/delete" do
  @choices = Choice.where("user_id" => params[:id])
  @choices.each do |choice|
    choice.delete
  end

  @user = User.find_by_id(params[:id])
  @user.delete
  

  redirect "/"
end

MyApp.get "/users/:id/process_search" do
  @locations_and_prices = {}
  @current_user = User.find_by_id(session["user_id"])
  @airport_codes = @current_user.get_airport_codes(@current_user.id)
  @airport_codes.each do |code|
    
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

  response_key_value_data = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV["GOOGLE_FLIGHT_API_KEY"]}",
    { 
    :body => request_data.to_json,
    :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  })

  @locations_and_prices[code] = response_key_value_data["trips"]["tripOption"][0]["saleTotal"] #returns {"JFK"=>"USD549.36", "GUA"=>"USD554.40", "LHR"=>"USD1421.90", "YUL"=>"USD316.85", "TUS"=>"USD475.10"}
  end

  @gtfo_arr = @current_user.get_price_array(@current_user.id, @locations_and_prices) #returns ["USD549.36", "USD554.4", "USD316.85", "USD475.1"]

  @returnable_location_and_price_hash = @current_user.get_codes_and_prices(@current_user.id, @locations_and_prices) #returns {nil=>475.1}
  @returnable_location_and_price_array = @returnable_location_and_price_hash.to_a

  @return_this = []
  @returnable_location_and_price_array.each do |i|
    @return_this << (i[0] + " -- " + i[1])
  end
  
  erb :"users/display_results"
end