class AddDownloadFieldFillPermission < ActiveRecord::Migration
  def up
    Permission.create!(action: :download, subject_class: 'FieldFill')
  end

  def down
    Permission.where(action: :download, subject_class: 'FieldFill').destroy_all
  end
end
