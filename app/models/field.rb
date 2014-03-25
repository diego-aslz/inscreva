# -*- encoding : utf-8 -*-
class Field < ActiveRecord::Base
  VALID_TYPES = [ :string, :text, :boolean, :country, :date, :file, :select,
      :check_boxes ]
  TYPES_WITH_EXTRA = [:select, :check_boxes]

  belongs_to :event
  has_many :field_fills, dependent: :destroy
  validates_presence_of :field_type, :name
  validates_inclusion_of :field_type, in: VALID_TYPES.map(&:to_s), if: :field_type
  serialize :allowed_file_extensions, Array

  after_initialize :default_values

  def select_options
    return nil if extra.blank?
    options = extra.split /\n/
    options.map { |opt| opt.strip.split('=').reverse }
  end

  def select_value(key)
    return nil if select_options.blank? or key.blank?
    select_options.select{ |opt| opt[1] == key }[0][0]
  end

  %w(file date text).each do |type|
    define_method "#{type}?" do
      field_type == type
    end
  end

  def default_values
    self.field_type = 'string' unless self.field_type
  end

  def self.type_to_s(type)
    I18n.t("types.#{type}")
  end

  def self.valid_types_to_collection
    Hash[Field::VALID_TYPES.map { |sym| [type_to_s(sym), sym] }]
  end
end
