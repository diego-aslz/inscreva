class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    # Any user
    can :create, Subscription do |sub|
      sub.event && sub.event.ongoing?
    end

    # Admin users
    if user.admin?
      can :manage, :all
      cannot :mine, Subscription unless user.subscriptions.any?
    # Subscribers
    elsif user.subscriptions.any?
      can [:show, :mine, :receipt], Subscription, user_id: user.id
      can :update, Subscription do |sub|
        sub.user_id == user.id && sub.event && sub.event.ongoing?
      end
      can :download, FieldFill, subscription: { id: user.subscription_ids }
    end

    # Users with permissions
    for delegation in user.delegations
      delegation.permissions.each do |p|
        if p.target_class == Event
          can p.action.to_sym, p.target_class, id: delegation.event_id
        else
          can p.action.to_sym, p.target_class, event_id: delegation.event_id
        end
      end
    end
  end
end
