class SearchService
  SEARCH_TYPES = %w[all question answer comment user].freeze

  def self.call(params)
    search_query = params[:search_query]
    search_by    = params[:search_by]

    return [] if search_query.blank? || !SEARCH_TYPES.include?(search_by)

    search_query = ThinkingSphinx::Query.escape(search_query)

    if search_by == 'all'
      ThinkingSphinx.search(search_query)
    else
      Object.const_get(search_by.capitalize).search(search_query)
    end
  end
end
