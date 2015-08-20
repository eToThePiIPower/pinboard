class Pin < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :description, :user_id
  
  has_attached_file :image, styles: { medium: "300x300>", large: "600x600>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
