MyApp.get "/process_search" do
  # locations_and_prices = {}

  # @current_user.destinations.each do |d|
  #   ........

  # end

  request_data = {
    "request" => {
      "passengers" => {
        "adultCount" => "1"
      },
      "slice" => [
        {
          "origin" => "OMA",
          "destination" => "LAX",
          "date" => "2016-04-12"
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

  binding.pry # response_key_value_data["flights"][0]["info"][1]["cost"]

  # locations_and_prices[d] = response_key_value_data["flights"][0]["info"][1]["cost"]
end

MyApp.get "/logins/new" do
  erb :"/logins/new"
end

MyApp.post "/logins/create" do
  @user = User.find_by_username(params[:username])
  if @user.password == params[:password]
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}/profile"
  else
    redirect "/logins/new"
  end
end

MyApp.get "/logins/delete" do
  @current_user = User.find_by_id(session[:user_id])
  if @current_user == nil
    redirect "/"
  else
    session[:user_id] == nil
    redirect "/"
  end
end