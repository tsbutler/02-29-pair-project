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
  @user.save_choice_objects(choices, @user.id)

  redirect "/logins/new"
end

MyApp.before "/users/:id/*" do
  @current_user = User.find_by_id(session[:user_id])
  if @current_user == nil
    redirect "/logins/new"
  end
end

MyApp.get "/users/:id/profile" do
  @user = User.find_by_id(params[:id])
  @choices = Choice.where("user_id" => params[:id])
  @destinations = Destination.all
  erb :"users/profile"
end

MyApp.get "/users/:id/edit" do
  @destinations = Destination.all
  @user = User.find_by_id(params[:id])
  @dest_id_array = @user.make_choice_array(@user.id)
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
    @user.delete_users_choices(@user.id)
  end

  @user.save_choice_objects(choices, params[:id])

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