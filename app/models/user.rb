class User < ActiveRecord::Base
	has_many :courses, :dependent => :delete_all
	validates :name, presence: true
	validates_uniqueness_of :name
	accepts_nested_attributes_for :courses, :allow_destroy => true
end
