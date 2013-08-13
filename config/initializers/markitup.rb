Markitup::Rails.configure do |config|
  config.formatter = -> markup { ApplicationHelper.redcarpet.render(markup) }
  config.layout = false
end
