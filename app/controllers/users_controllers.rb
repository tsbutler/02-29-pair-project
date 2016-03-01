MyApp.get "/users" do
  @users = User.all
  erb :"users/index"
end

MyApp.get "/users/new" do
  erb :"users/new"
end

MyApp.post "/users/create" do
  @user = User.new
  @user.name = params[:name]
  @user.username = params[:username]
  @user.password = params[:password]
  @user.email = params[:email]
  @user.budget = params[:budget]
  @user.save
  
  choices = [params["destination_id_1"], params["destination_id_2"], params["destination_id_3"], params["destination_id_4"], params["destination_id_5"]]
  choices.each do |choice|
    @choice = Choice.new
    @choice.user_id = @user.id
    @choice.destination_id = choice
    @choice.save
  end

  redirect "/users/#{@user.id}/profile"
end

MyApp.get "/users/:id/profile" do
  @user = User.find_by_id(params[:id])
  erb :"users/profile"
end

MyApp.get "/users/:id/edit" do
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => @user.id)
  erb :"users/edit"
end

MyApp.post "/users/:id/update" do
  @user = User.find_by_id(params[:id])
  binding.pry
  @user.name = params[:name]
  @user.username = params[:username]
  @user.password = params[:password]
  @user.email = params[:email]
  @user.budget = params[:budget]
  @user.save


  choices = [params["destination_id_1"], params["destination_id_2"], params["destination_id_3"], params["destination_id_4"], params["destination_id_5"]]
  choices.each do |choice|
    @choice = Choice.new
    @choice.user_id = @user.id
    @choice.destination_id = choice
    @choice.save
  end

  redirect "/users/#{@user.id}/profile"
end

MyApp.post "users/:id/delete" do
  @user = User.find_by_id(params[:id])
  redirect "/"
end
