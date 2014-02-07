module FillInHelper
  def fill_in_typeahead field, with, container=page
    page.execute_script "$('input[typeahead]').unbind('blur')"
    fill_in field, with: with
    container.find('li.active').click
  end
end

RSpec.configure do |config|
  config.include FillInHelper, type: :feature
end
