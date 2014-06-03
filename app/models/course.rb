class Course < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates_uniqueness_of :name
  accepts_nested_attributes_for :user, :allow_destroy => true
end
