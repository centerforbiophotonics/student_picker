class Course < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  accepts_nested_attributes_for :user, :allow_destroy => true
end
