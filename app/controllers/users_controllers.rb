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

  binding.pry 
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

  redirect "/users/#{@user.id}/profile"
end

MyApp.get "/users/:id/profile" do
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => params[:id])
  erb :"users/profile"
end

MyApp.get "/users/:id/edit" do
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => @user.id)
  erb :"users/edit"
end

MyApp.post "/users/:id/update" do
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

MyApp.get "/users/process_search" do
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
          "date" => Date.today.next_day.strftime("%Y-%m-%d")
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
