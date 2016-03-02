MyApp.get "/destinations/new" do
  erb :"destinations/new"
end

MyApp.post "/destinations/create" do
  @destination = Destination.new
  @destination.name = params[:name]
  @destination.airport_code = params[:airport_code]
  if @destination.is_valid? == false
    halt erb :"/destinations/error"
  else
    @destination.save
    redirect "/destinations/index"
  end
end

MyApp.get "/destinations/index" do
  @destinations = Destination.all
  erb :"/destinations/index"
end

MyApp.get "/destinations/:id/edit" do
  @destination = Destination.find_by_id(params[:id])
  erb :"/destinations/edit"
end

MyApp.post "/destinations/:id/update" do
  @destination = Destination.find_by_id(params[:id])
  @destination.name = params[:name]
  @destination.airport_code = params[:airport_code]
  if @destination.is_valid? == false
    halt erb :"/destinations/error"
  else
    @destination.save
    redirect "/destinations/index"
  end
end

MyApp.post "/destinations/:id/delete" do
  @destination = Destination.find_by_id(params[:id])
  @destination.delete
  redirect "/destinations/index"
end