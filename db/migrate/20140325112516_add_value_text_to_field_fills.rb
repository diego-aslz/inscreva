class AddValueTextToFieldFills < ActiveRecord::Migration
  def change
    add_column :field_fills, :value_text, :text
  end

  def migrate direction
    super

    if direction == :up
      count = FieldFill.joins(:field).where('fields.field_type = ?', 'text').
        update_all('value_text = value')
      puts "#{count} field fill(s) of type 'text' got updated."
    end
  end
end
