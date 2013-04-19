ActiveAdmin.register Event do
  filter :name
  filter :opens_at
  filter :closes_at

  index do
    column :name
    column :opens_at
    column :closes_at
    column :subscriptions do |e|
      0
    end
    default_actions
  end
end
