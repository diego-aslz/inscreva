module SubscriptionsHelper
  def link_to_check_id_card
    link_to t(:continue), '#', id: 'check_id_card',
        'data-url' => check_id_path(format: :js)
  end
end
