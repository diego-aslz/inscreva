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
    for delegation in user.delegations
      delegation.permissions.each do |p|
        klass = p.subject_class.constantize
        if klass == Event
          can p.action.to_sym, klass, id: delegation.event_id
        else
          can p.action.to_sym, klass, event_id: delegation.event_id
        end
      end
    end
    can [:new, :create], Subscription
    can :show, Page
  end
end
