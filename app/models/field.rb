# -*- encoding : utf-8 -*-
class Field < ActiveRecord::Base
  VALID_TYPES = { "Texto" => "string", "Texto Multilinha" => "text",
      "Lógico" => "boolean", "País" => 'country', "Data" => 'date',
      "Arquivo" => 'file', "Única Escolha" => 'select',
      "Múltipla Escolha" => 'check_boxes' }
  TYPES_WITH_EXTRA = [:select, :check_boxes]

  belongs_to :event
  has_many :field_fills, dependent: :destroy
  attr_accessible :field_type, :name, :extra, :required, :show_receipt,
      :group_name, :priority, :searchable
  validates_presence_of :field_type, :name
  validates_inclusion_of :field_type, in: VALID_TYPES.values, if: :field_type

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

  def file?
    field_type == 'file'
  end

  def default_values
    self.field_type = 'string' unless self.field_type
  end

  def self.type_to_s(type)
    VALID_TYPES.select{ |k,v| v == type }.keys[0]
  end
end
