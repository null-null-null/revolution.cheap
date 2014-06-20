class Project < ActiveRecord::Base
  attr_accessor :project_logo_id
  include ActsAsTaggable
  include ValidatorRegex

  extend FriendlyId
  friendly_id :title, use: :history

  has_many :project_roles, dependent: :destroy
  has_many :users, through: :project_roles, source: :user
  has_one :project_logo, dependent: :destroy
  has_one :slideshow, as: :slideshowable, dependent: :destroy

  validates :description, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :source, allow_blank: true, uri: { format: VALID_URI_REGEX }
  validates :title, presence: true, length: { in: 3..120 }
  validates :website, allow_blank: true, uri: { format: VALID_URI_REGEX }

  accepts_nested_attributes_for :project_roles, allow_destroy: true

  after_save :set_project_logo

  def users_include?(user_in_question)
    users.each do |user|
      return true if user == user_in_question
    end
    return false
  end

  private
  def set_project_logo
    project_logo = ProjectLogo.find(project_logo_id)
    project_logo.project = self
    project_logo.save
  end
end
