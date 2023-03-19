module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :rateable, dependent: :destroy
  end

  def uprate(user)
    rates.create!(user: user, value: 1) unless rates.exists?(user: user)
  end

  def downrate(user)
    rates.create!(user: user, value: -1) unless rates.exists?(user: user)
  end

  def cancel_rate(user)
    rates.find_by(user: user)&.destroy
  end

  def total_rating
    rates.sum(&:value)
  end
end
