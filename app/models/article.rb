class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_many :pictures
  has_many :authorables
  has_many :authors, through: :authorables

  attr_accessible :content, :hero_image, :short_hero_image, :published, :published_at, :sub_title, :teaser, :title, :pictures,
                  :author_ids, :hero_image_cache, :tag_list, :gplus_url, :featured, :document, :document_cache, :hero_image_file, :remove_document
  attr_accessor :hero_image_file
  accepts_nested_attributes_for :pictures, :authors

  mount_uploader :hero_image, HeroImageUploader
  mount_uploader :document, DocumentUploader

  paginates_per 10

  acts_as_taggable

  validates :title, :content, :author_ids, :published_at, presence: true
  validate :one_image_selected


  after_save :update_used_images, :refresh_sitemap

  scope :published, where(published: true).order("featured DESC, published_at DESC")

  HERO_IMAGES = %w(blog_hero_android.jpg blog_hero_design.jpg blog_hero_development.jpg blog_hero_photography.jpg blog_hero_writing.jpg)

  def short_hero_image_url
    "#{self.short_hero_image}"
  end

  def used_images
    result = self.content.scan(/!\[.*\]\(.*\/image\/(\d.*)\/.*\)/)
    image_ids = result.nil? ? nil : result.map{ |i| i[0].to_i }.uniq
    image_ids
  end

  def image_url
    self.hero_image? ? self.hero_image_url : self.short_hero_image
  end

  def sub_title
    read_attribute(:sub_title) || ''
  end

private


  def update_used_images
    ActionController::Base.new.expire_fragment(self)
    image_ids = self.used_images
    if !image_ids.nil?
      Picture.find_all_by_id(image_ids).each do |picture|
        picture.update_attributes(article_id: self.id)
      end
    end
  end

  def refresh_sitemap
    if self.published
      if Rails.env == 'production'
        SitemapGenerator::Interpreter.run(config_file: ENV["CONFIG_FILE"])
        SitemapGenerator::Sitemap.ping_search_engines 
      end
    end
  end

  def one_image_selected
    if both_images_selected || no_image_selected
      errors[:base] << 'You have to either select an image or upload one.'
    end
  end

  def both_images_selected
    hero_image.present? && short_hero_image.present?
  end

  def no_image_selected
    !hero_image.present? && !short_hero_image.present?
  end

end
