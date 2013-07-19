# -*- encoding : utf-8 -*-
ActiveAdmin.register Subscription do
  filter :event
  filter :number
  filter :name
  filter :email
  filter :created_at

  form do |f|
    f.inputs t(:details) do
      f.input :id_card
      f.input :name
      f.input :email
      f.has_many :field_fills, new_record: false, heading: false do |ff|
        input_fill ff
        # ff.input :file, as: :file
      end
    end
    f.actions
  end

  index do
    column :number
    column :name
    column :id_card
    column :email
    column :created_at
    default_actions only: [:show]
  end

  show do
    attributes_table do
      row :number
      row :name
      row :id_card
      row :email
      row :created_at
      row :print_receipt do
        link_to_receipt(subscription)
      end
    end
    panel EventField.model_name.human.pluralize do
      table_for subscription.field_fills, i18n: FieldFill do
        column :name do |fill|
          fill.event_field.name if fill.event_field
        end
        column :value do |fill|
          show_fill fill
        end
      end
    end
  end
end
