class ShortArticle < Article

  HERO_IMAGES = %w(blog_hero_android.jpg blog_hero_design.jpg blog_hero_development.jpg blog_hero_photography.jpg blog_hero_writing.jpg)

  validates :short_hero_image, :presence => true
  # def set_hero_image
  # 	self.hero_image = self.short_hero_image
  # end

  # def hero_image
  # 	self.short_hero_image
  # end

  # def hero_image=(image)
  # 	self.hero_image = self.short_hero_image
  # end

  def short_hero_image_url
    "#{self.short_hero_image}"
  end


end
