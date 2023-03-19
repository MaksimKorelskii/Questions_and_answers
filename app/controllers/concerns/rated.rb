module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_rateable, only: %i[ uprate downrate cancel ]
  end

  def uprate
    return render_error if current_user.author?(@rateable)

    @rateable.uprate(current_user)
    render_json
  end

  def downrate
    return render_error if current_user.author?(@rateable)

    @rateable.downrate(current_user)
    render_json
  end

  def cancel
    return render_error if current_user.author?(@rateable)

    @rateable.cancel_rate(current_user)
    render_json
  end

  private

  def render_json
    render json: { rating: @rateable.total_rating, resource_name: @rateable.class.to_s.downcase,
                   resource_id: @rateable.id }
  end

  def render_error
    render json: { message: "You're an author!" }, status: 422
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_rateable
    @rateable = model_klass.find(params[:id])
  end
end
