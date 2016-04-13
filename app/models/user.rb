class User < ActiveRecord::Base
has_and_belongs_to_many :events
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_UIN_REGEX = /[\d]/
  validates :uin,   presence: true, length: { maximum: 50 },   format: { with: VALID_UIN_REGEX },   uniqueness: true
  
end
