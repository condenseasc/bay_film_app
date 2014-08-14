class ImageComparison
  def self.duplicate_image?(image1_filename, image2_filename)
    img1 = Phashion::Image.new image1_filename
    img2 = Phashion::Image.new image2_filename

    img1.duplicate? img2
  end
end