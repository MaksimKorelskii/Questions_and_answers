ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes content
  indexes user.email, as: :user, sortable: true

  has user_id, created_at, updated_at, commentable_id, commentable_type
end
