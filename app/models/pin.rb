class Pin < ActiveRecord::Base
  belongs_to :user
  acts_as_votable
  validates_presence_of :title, :description, :user_id

  has_attached_file :image, styles: { medium: "300x300>", large: "600x600>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def votes
    self.get_likes.size
  end
end
