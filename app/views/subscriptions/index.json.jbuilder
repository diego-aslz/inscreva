
json.array! @subscriptions.includes(field_fills: :field).
  where("fields.field_type <> 'file'").references(:field_fills) do |subscription|

  json.extract! subscription, :created_at, :number, :name
  json.fills subscription.field_fills do |fill|
    json.name fill.field.name
    json.extract! fill, :field_id, :value

    if %w(checkboxes select country).include? fill.field.field_type
      json.description fill.value_to_s
    end
  end
end
