class UrlsController < ApplicationController

  def index
    @url = Url.new
  end

  def show
    @url = Url.find_by_short_url(params[:id])
    redirect_to @url.sanitized_url
  end

  def create
    @url = Url.new(url_params)
    @url.sanitize
    if @url.new_url?
      if @url.save
        redirect_to edit_url_path(@url)
      else
        render 'index'
      end
    else
      redirect_to edit_url_path(@url.find_duplicate)
    end
  end

  def edit
    page = (1..10).to_a.sample
    results = GoogleCustomSearchApi.search('komodo', page: page, searchType: 'image')
    result = (0..9).to_a.sample
    @image = results["items"][result]["link"]
    @url = Url.find(params[:id])
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end
