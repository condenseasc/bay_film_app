class ImageComparison
  def duplicate_image?(image1_filename, image2_filename)
    img1 = Phashion::Image.new image1
    img2 = Phashion::Image.new image2

    img1.duplicate? img2
  end
end