class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :courses, :dependent => :delete_all
	validates :name, presence: true
	validates_uniqueness_of :name
	accepts_nested_attributes_for :courses, :allow_destroy => true
end
