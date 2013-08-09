class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.subscriptions.any?
      can [:edit, :update, :show, :mine, :receipt], Subscription, user_id: user.id
      can :download, FieldFill, subscription: { id: user.subscription_ids }
    end
    can [:new, :create], Subscription
    can :show, Page
  end
end
