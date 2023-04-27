class SearchController < ApplicationController

  def index
    authorize! :index, SearchController

    @result = SearchService.call(search_params)
  end

  private

  def search_params
    params.permit(:search_query, :search_by)
  end
end
