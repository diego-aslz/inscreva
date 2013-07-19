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
      f.has_many :fields, allow_destroy: true, heading: false do |ff|
        ff.input :name
        ff.input :field_type, as: :select, collection: EventField::VALID_TYPES,
            include_blank: false, input_html: { class: :field_type,
                disabled: !ff.object.new_record? }
        ff.input :extra, wrapper_html: { class: :extra, data: { :'extra-types' =>
            EventField::TYPES_WITH_EXTRA } }
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

  show do
    attributes_table do
      row :name
      row :opens_at
      row :closes_at
      row :allow_edit do
        event.allow_edit ? t('yes') : t('no')
      end
      row :rules_url
      row :technical_email
      row :email
    end
    panel EventField.model_name.human.pluralize do
      table_for event.fields, i18n: EventField do
        column :name
        column :field_type do |field|
          EventField::VALID_TYPES.key(field.field_type)
        end
        column :show_receipt do |field|
          field.show_receipt ? t('yes') : t('no')
        end
      end
    end
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
