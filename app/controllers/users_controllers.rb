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
  redirect "/"
end

MyApp.get "/users" do
  @users = User.all
  erb :"users/index"
end

MyApp.get "/users/:id" do
  @user = User.find_by_id(params[:id])
  erb :"users/show"
end

MyApp.get "/users/:id/edit" do
  @user = User.find_by_id(params[:id])
  erb :"users/edit"
end

MyApp.post "/users/:id/update" do
  @user = User.find_by_id(params[:id])
  redirect "/"
end

MyApp.post "users/:id/delete" do
  @user = User.find_by_id(params[:id])
  redirect "/"
end