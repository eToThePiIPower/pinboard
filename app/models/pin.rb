class Pin < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :description, :user_id
end
