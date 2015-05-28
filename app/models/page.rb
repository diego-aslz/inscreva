class Page < ActiveRecord::Base
  has_many :pages
  has_many :files, class_name: 'PageFile', dependent: :destroy
  belongs_to :page
  belongs_to :event, :counter_cache => true

  accepts_nested_attributes_for :files, allow_destroy: true, reject_if:
      lambda { |f| f[:name].blank? }

  validates_presence_of :name, :event, :title
  validates_uniqueness_of :name, scope: :event_id

  before_save :correct_name, :clear_mains

  def self.search(term)
    term = "%#{term}%"
    where(arel_table[:name].matches(term).or(arel_table[:title].matches(term)))
  end

  def self.by_language(lang)
    language = arel_table[:language]
    where(language.eq(nil).or(language.eq('')).or(language.eq(lang)))
  end

  def event_name=(e) end

  def correct_name
    if self.name
      self.name.gsub! ' ', '-'
      self.name.gsub! /[^\w_\-]/i, ''
    end
  end

  def event_name
    event.name if event
  end

  def clear_mains
    if self.main
      ws = self.event.pages.where(main: true)
      ws = ws.by_language(self.language) unless self.language.nil? || self.language.empty?
      ws = ws.where.not(id: self.id) if self.id
      ws.update_all(main: false)
    end
  end
end
