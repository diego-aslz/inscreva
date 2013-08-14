module SubscriptionsHelper
  def minilink_to_receipt(subscription)
    link_to icon_tag('icon-print icon-white'), receipt_subscription_path(subscription),
        target: :_blank, title: t(:print_receipt),
        class: 'btn btn-mini btn-success' if can?(:receipt, subscription)
  end

  def link_to_receipt(subscription)
    link_to t(:print_receipt), receipt_subscription_path(subscription),
        target: :_blank, class: 'btn btn-success' if can?(:receipt, subscription)
  end

  def show_fill(fill)
    field = fill.field
    render "subscriptions/fields/#{field.field_type}_show",
        value: fill.value, field: field, fill: fill if field
  end

  def input_fill(form)
    fill = form.object
    field = fill.field
    render "subscriptions/fields/#{field.field_type}_field",
        fill: fill, field: field, f: form
  end
end
