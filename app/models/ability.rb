class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      cannot :mine, Subscription unless user.subscriptions.any?
    elsif user.subscriptions.any?
      can [:update, :show, :mine, :receipt], Subscription, user_id: user.id
      can :download, FieldFill, subscription: { id: user.subscription_ids }
    end
    for delegation in user.delegations
      delegation.permissions.each do |p|
        if p.target_class == Event
          can p.action.to_sym, p.target_class, id: delegation.event_id
        else
          can p.action.to_sym, p.target_class, event_id: delegation.event_id
        end
      end
    end
    can :create, Subscription
  end
end
