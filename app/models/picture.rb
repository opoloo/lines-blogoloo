class Picture < ActiveRecord::Base
  belongs_to :article, touch: true
  attr_accessible :image, :name, :article_id

  mount_uploader :image, PictureUploader

  before_create :default_name

  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end

end
