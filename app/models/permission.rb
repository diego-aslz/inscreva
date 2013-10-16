class Permission < ActiveRecord::Base
  validates_presence_of :action, :subject_class
  validates_uniqueness_of :action, scope: :subject_class
  has_and_belongs_to_many :roles

  def to_s
    I18n.t("permissions.#{subject_class.underscore}.#{action}", default:
        I18n.t("permissions.#{action}", model: target_class.model_name.human.pluralize,
            default: "#{action} #{subject_class}"))
  end

  def target_class
    subject_class.constantize
  end

  def self.subject_classes
    select(:subject_class).order(:subject_class).uniq.map(&:subject_class)
  end
end
