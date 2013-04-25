module HomeHelper
  def link_to_subscribe(event)
    link_to t(:subscribe), new_subscription_path + '?event_id=' + event.id.to_s
  end
end
