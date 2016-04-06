MyApp.get "/" do
  @hide_nav = true
  erb :"main/main"
end