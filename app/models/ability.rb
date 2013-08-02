class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? Role.new(name: 'superadmin')
      can :manage, :all
    elsif user.is_a? User and user.subscriptions.any?
      can [:edit, :update, :show, :index, :receipt], Subscription, user_id: user.id
      can :download, FieldFill, subscription: { id: user.subscription_ids }
    end
    can [:new, :create], Subscription
    can :show, Wiki
  end
end
