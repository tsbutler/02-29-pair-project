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