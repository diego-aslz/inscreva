module EventHelper
  def to_ng event
    Jbuilder.encode do |json|
      json.extract! event, :id, :name, :description, :identifier

      json.fields event.fields do |field|
        json.(field, :id, :group_name, :name, :field_type, :extra,
          :hint, :required, :show_receipt, :searchable, :max_file_size,
          :allowed_file_extensions, :priority, :is_numeric)
        json.editing field.new_record?
      end if event.fields

      json.delegations event.delegations.includes(:user) do |delegation|
        json.(delegation, :id, :role_id, :user_id)
        json.role_id(delegation.role_id || '')
        json.user do
          json.extract! delegation.user, :id, :name if delegation.user
        end
        json.editing delegation.new_record?
      end if event.delegations
    end
  end
end
