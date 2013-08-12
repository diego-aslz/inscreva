class AddLanguageToPages < ActiveRecord::Migration
  def change
    add_column :pages, :language, :string
  end
end
