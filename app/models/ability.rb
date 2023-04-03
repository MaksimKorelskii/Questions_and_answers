# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def user_abilities
    guest_abilities
    # can :destroy, Question, { user_id: user.id }
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], { author_id: user.id } #author: user
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end
end
