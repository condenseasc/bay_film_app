# class Still < ActiveRecord::Base
#   belongs_to :event, inverse_of: :stills
#   belongs_to :series, inverse_of: :stills
#   has_attached_file :image, styles: { capsule_medium: "300" }

#   has_and_belongs_to_many :documents
#   belongs_to :document
#   belongs_to :document, 
#   belongs_to :stillable, polymorphic: true

#   validates_attachment :image, 
#     presence: true,
#     content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] }
# end

class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :asset, styles: { medium: "300" }
  validates_attachment :asset, 
    presence: true,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] }
end

# class Still < Image
#   belongs_to :stillable, polymorphic: true


# end

