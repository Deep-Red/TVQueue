require 'open-uri'
class QueuedEpisodesController < ApplicationController
  before_action :authenticate_user!

  def nothing
    response = open("https://api.themoviedb.org/3/tv/#{params[:id]}/season/1?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read

    @season = JSON.parse(response)
  end

  def index
    @user = current_user

  end

end