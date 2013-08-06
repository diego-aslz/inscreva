module HomeHelper
  def link_to_subscribe(event)
    link_to t(:subscribe), subscribe_path(event),
        class: 'btn btn-primary'
  end

  def subscribe_path(event)
    new_event_subscription_path(event)
  end
end
