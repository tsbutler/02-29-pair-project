MyApp.get "/destinations/new" do
  erb :"destinations/new"
end

MyApp.post "/destinations/create" do
  @destination = Destination.new
  @destination.name = params[:name]
  @destination.airport_code = params[:airport_code]
  @destination.save
  redirect "/destinations/index"
end

MyApp.get "/destinations/index" do
  @destinations = Destination.all
  erb :"/destinations/index"
end