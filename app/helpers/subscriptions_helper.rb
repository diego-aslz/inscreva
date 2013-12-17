module SubscriptionsHelper
  def minilink_to_receipt(subscription)
    link_to icon_tag('icon-print'), receipt_subscription_path(subscription),
        target: :_blank, title: t(:print_receipt),
        class: 'btn btn-xs btn-success' if can?(:receipt, subscription)
  end

  def link_to_receipt(subscription)
    link_to t(:print_receipt), receipt_subscription_path(subscription),
        target: :_blank, class: 'btn btn-success' if can?(:receipt, subscription)
  end

  def show_fill(fill)
    return '' unless fill
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

  def hide_params(params, options={})
    only, prefix = options[:only], options[:prefix]
    pars = only.nil? ? params : params.slice(*(only.is_a?(Hash) ? only.keys : [only]))
    result = ''
    pars.each_pair do |k, v|
      value = v
      id = prefix.nil? ? k : "#{prefix}[#{k}]"
      if value.is_a? Hash
        only.is_a?(Hash) ? only = only[k] : only = nil
        result += hide_params(value, only: only, prefix: id)
      elsif value.is_a? Array
        for val in value
          result += hidden_field_tag(id + '[]', val)
        end
        result += hidden_field_tag(id + '[]', '')
      else
        result += hidden_field_tag(id, value)
      end
    end
    result.html_safe
  end

  def permitted_selects
    params[:selects].try(:&, ['email', 'id_card']) || []
  end
end
