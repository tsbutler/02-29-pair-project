#I think there might be a bit too much work being done in this controller
#for maintainability's sake.  Look into fixing that.

require 'date'

MyApp.get "/users" do
  @users = User.all
  erb :"users/index"
end

MyApp.get "/users/new" do
  @hide_nav = true
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
  @choices = Choice.where("user_id" => @user.id)
  @destinations = Destination.all
  erb :"users/profile"
end

MyApp.get "/users/:id/edit" do
  @destinations = Destination.all
  @user = User.find_by_id(params[:id])
  @dest_id_array = @user.get_destination_ids
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
    @user.delete_users_choices
  end
  @user.save_choice_objects(choices)

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
  @return_this = return_this(params[:id])
  erb :"users/display_results"
end