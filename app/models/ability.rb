class Ability
  include CanCan::Ability

  def initialize(user)
    # Any user
    can :create, Subscription do |sub|
      sub.event && sub.event.ongoing?
    end

    return unless user

    # Admin users
    if user.admin?
      can :manage, :all
      cannot :mine, Subscription unless user.subscriptions.any?
    else
      # Event created by user
      if user.can_create_events?
        can :create, Event
        can [:read, :update]         , Event, created_by_id: user.id
        can [:read, :update, :create], Page , event: { created_by_id: user.id }
        can [:read, :update, :create, :receipt], Subscription do |s|
          s.event && s.event.created_by_id == user.id
        end
        can [:download], FieldFill, subscription: { event: { created_by_id: user.id } }
        can [:create],   Notification, event: { created_by_id: user.id }
      end

      # Subscribers
      if user.subscriptions.any?
        can [:show, :mine, :receipt], Subscription, user_id: user.id
        can :update, Subscription do |sub|
          sub.user_id == user.id && sub.event && sub.event.ongoing?
        end
        can :download, FieldFill, subscription: { id: user.subscription_ids }
      end
    end

    # Users with permissions
    for delegation in user.delegations.includes(:permissions)
      delegation.permissions.each do |p|
        if p.target_class == Event
          can p.action.to_sym, p.target_class, id: delegation.event_id
        elsif p.target_class == FieldFill
          can p.action.to_sym, p.target_class, subscription: { event_id: delegation.event_id }
        else
          can p.action.to_sym, p.target_class, event_id: delegation.event_id
        end
      end
    end
  end
end
