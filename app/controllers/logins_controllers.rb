MyApp.get "/logins/new" do
  erb :"/logins/new"
end

MyApp.post "/logins/create" do
  @user = User.find_by_username(params[:username])
  redirect "/users/<%=@user.id%>/profile"
end