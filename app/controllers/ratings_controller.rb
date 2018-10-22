class RatingsController < ApplicationController
  def index
    if Rails.cache.read("rating recent").nil? 
      @recent_ratings = Rating.recent
      @top_breweries = Brewery.top 3
      @top_users = User.top 3
      @top_beers = Beer.top 3
      @top_styles = Style.top 4
    else
      TestJob.perform_async
      @recent_ratings = Rails.cache.read("rating recent")
      @top_breweries = Rails.cache.read("brewery top 3")
      @top_users = Rails.cache.read("user top 3")
      @top_beers = Rails.cache.read("beer top 3")
      @top_styles = Rails.cache.read("style top 3")
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      redirect_to @rating.beer
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
