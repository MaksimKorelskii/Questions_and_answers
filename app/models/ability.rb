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

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer], { author_id: user.id }

    can :destroy, [Question, Answer], { author_id: user.id }

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :mark_as_best, Answer do |answer|
      user.author?(answer.question)
    end

    can [:uprate, :downrate, :cancel], [Question, Answer] do |rateable|
      !user.author?(rateable)
    end
  end
end
