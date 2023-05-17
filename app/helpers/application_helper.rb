module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at)&.to_s(:usec)

    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at || 0}"
  end
end
