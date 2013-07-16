class EventField < ActiveRecord::Base
  belongs_to :event
  attr_accessible :field_type, :name, :extra, :required
  validates_presence_of :field_type, :name

  def select_options
    return nil if extra.blank?
    options = extra.split /\n/
    options.map { |opt| opt.split('=').reverse }
  end

  def select_value(key)
    return nil if select_options.blank? or key.blank?
    select_options.select{ |opt| opt[1] == key }[0][0]
  end
end
