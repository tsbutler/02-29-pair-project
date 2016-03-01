MyApp.get "/users/new" do
  erb :"users/new"
end

MyApp.post "/users/create" do
  redirect "/"
end

MyApp.get "/users" do
  erb :"users/index"
end

MyApp.get "/users/:id" do
  erb :"users/show"
end

MyApp.get "/users/:id/edit" do
  erb :"users/edit"
end