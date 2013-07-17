# -*- encoding : utf-8 -*-
ActiveAdmin.register Event do
  filter :name
  filter :opens_at
  filter :closes_at

  form do |f|
    f.inputs t(:details) do
      f.input :name
      f.input :opens_at
      f.input :closes_at
      f.input :allow_edit
      f.input :rules_url
      f.input :technical_email
      f.input :email
    end
    f.inputs t(:event_fields) do
      f.has_many :fields do |ff|
        ff.input :name
        ff.input :field_type, as: :select, collection: { "Texto" => "string",
            "Texto Multilinha" => "text", "Lógico" => "boolean", "País" => 'country',
            "Data" => 'date', "Arquivo" => 'file', "Única Escolha" => 'select',
            "Múltipla Escolha" => 'check_boxes'}, include_blank: false
        ff.input :extra
        ff.input :required
        ff.input :show_receipt
      end
    end
    f.actions
  end

  index do
    column :name
    column :opens_at
    column :closes_at
    column :subscriptions do |e|
      e.subscriptions.count
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
