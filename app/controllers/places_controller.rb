class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.one_place(params[:id])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      @weather = ApixuApi.weather_in(params[:city])
      session[:city] = params[:city]
      render :index
    end
  end
end
