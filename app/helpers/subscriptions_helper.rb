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

  def filter_valid?(field_id, value, type)
    (type == "date" and !(value[:b].blank? and value[:e].blank?)) or
    (type != "date" and not value.blank?)
  end

  def filter_clause(field_id, value, type)
    if type == "date"
      clauses = ["field_fills.field_id = ?"]
      pars = [field_id]
      if !value[:b].blank? && (val = to_date(value[:b]))
        clauses << "field_fills.value >= ?"
        pars << val
      end
      if !value[:e].blank? && (val = to_date(value[:e]))
        clauses << "field_fills.value <= ?"
        pars << val
      end
      [clauses.join(' and '), pars]
    elsif %w(string text select).include?(type)
      ["field_fills.field_id = ? and field_fills.value like ?", [field_id, "%#{value}%"]]
    elsif type == "check_boxes"
      clauses = []
      pars = [field_id]
      for val in value
        clauses << "FIND_IN_SET(?, field_fills.value) > 0"
        pars << val
      end
      ["field_fills.field_id = ? and (#{clauses.join ' or '})", pars]
    else
      ["field_fills.field_id = ? and field_fills.value = ?", [field_id, value]]
    end
  end

  def to_date(str)
    begin Date.strptime(str, '%d/%m/%Y').strftime('%Y-%m-%d') rescue nil end
  end
end
