class Pin < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :description, :user_id
  
  has_attached_file :image, style: { medium: "300x300" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
