# {Article}s are the core of the lines blog. 
# 
# An {Article} must have on or more {Author}s through {Authorable}.
# 
# An article extends FriendlyId to provide meaningful slugs instead of the usual id value. 
# 
# Slugs are unique and contain the article's title. A incremental numerical value
# is added to the slug title if the it already exists in the database.
class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  # Relations
  has_many :pictures
  has_many :authorables
  has_many :authors, through: :authorables

  # Attribute access control
  attr_accessible :content, :hero_image, :short_hero_image, :published, :published_at, :sub_title, :title, :pictures,
                  :author_ids, :hero_image_cache, :tag_list, :gplus_url, :featured, :document, :document_cache, :hero_image_file, :remove_document
  attr_accessor :hero_image_file
  accepts_nested_attributes_for :pictures, :authors

  # Mount Carrierwave uploaders
  mount_uploader :hero_image, HeroImageUploader
  mount_uploader :document, DocumentUploader

  # Pagination and tagging
  paginates_per CONFIG[:articles_per_page]
  acts_as_taggable

  # Validations
  validates :title, :content, :author_ids, :published_at, presence: true
  validate :one_image_selected

  # Callbacks
  after_save :update_used_images, :refresh_sitemap

  # Model Scopes
  scope :published, where(published: true).order("featured DESC, published_at DESC")

  # Predifined hero images.
  # Images are loaded from the <tt>public/heroes</tt> directory
  HERO_IMAGES = %w(001_dark.jpg 001.jpg 002_dark.jpg 002.jpg 003_dark.jpg 003.jpg)

  # Returns URL of selected image from HERO_IMAGES array
  def short_hero_image_url
    "#{self.short_hero_image}"
  end

  # Returns array of images used in content
  def used_images
    result = content.scan(/!\[.*\]\(.*\/image\/(\d.*)\/.*\)/)
    image_ids = result.nil? ? nil : result.map{ |i| i[0].to_i }.uniq
    image_ids
  end

  # Returns the url for the hero image
  def image_url
    self.hero_image? ? self.hero_image_url : self.short_hero_image
  end

  # Returns value of subtitle
  def sub_title
    read_attribute(:sub_title) || ''
  end

private

  # Finds images used in an articles content and associates each
  # image to the blog article
  def update_used_images
    ActionController::Base.new.expire_fragment(self)
    image_ids = self.used_images
    if !image_ids.nil?
      Picture.find_all_by_id(image_ids).each do |picture|
        picture.update_attributes(article_id: self.id)
      end
    end
  end

  # Refreshes the sitemap and pings the search engines
  def refresh_sitemap
    if self.published
      if Rails.env == 'production'
        SitemapGenerator::Interpreter.run(config_file: ENV["CONFIG_FILE"])
        SitemapGenerator::Sitemap.ping_search_engines 
      end
    end
  end

  # Validates if either a predefined hero image is selected or a custom hero
  # image uploaded. 
  def one_image_selected
    if both_images_selected || no_image_selected
      errors[:base] << 'You have to either select an image or upload one.'
    end
  end

  # Returns true if both a hero image is uploaded and a predefined hero image is selected
  def both_images_selected
    hero_image.present? && short_hero_image.present?
  end

  # Returns false if no hero image is selected or uploaded
  def no_image_selected
    !hero_image.present? && !short_hero_image.present?
  end

end
