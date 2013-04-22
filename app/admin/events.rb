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

  controller do
    def new
      @event = Event.new
      @event.opens_at = Time.zone.now.change(:hour => 0)
      @event.closes_at = Time.zone.now.change(:hour => 23, :min => 59)
      new!
    end
  end
end
