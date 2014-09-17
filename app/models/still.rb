class Still < ActiveRecord::Base
  belongs_to :event, inverse_of: :stills
  belongs_to :series, inverse_of: :stills
  has_attached_file :image, styles: { capsule_medium: "300" }

  validates_attachment :image, 
    presence: true,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] }
end
