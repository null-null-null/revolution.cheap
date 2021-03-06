class ProjectRole < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :name, presence: true, length: { in: 3..30 }, unless: :user_present?
  validates :title, presence: true, length: { in: 3..30 }

  after_create { user.increment!(:projects_count) if user }
  after_destroy { user.decrement!(:projects_count) if user }

  def user_present?
    user.present?
  end
end
