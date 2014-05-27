class User < ActiveRecord::Base
	has_many :courses
	validates :name, presence: true
	validates_uniqueness_of :name
	accepts_nested_attributes_for :courses
end
