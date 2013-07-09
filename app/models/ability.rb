class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? Role.new(name: 'superadmin')
      can :manage, :all
    elsif user.is_a? AdminUser
      can :read, ActiveAdmin::Page, :name => "Dashboard"
    elsif user.subscriptions.any?
      can [:edit, :update, :show, :index], Subscription, user_id: user.id
    end
    can [:new, :create], Subscription
  end
end
