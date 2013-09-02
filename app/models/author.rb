class Author < ActiveRecord::Base
  
  attr_accessible :email, :name, :description, :gplus_profile
  
  has_many :authorables
  has_many :articles, through: :authorables
  
  validates :name, :email, :description, presence: true

  before_destroy :check_for_articles

  def first_name
  	self.name.split(" ").first
  end

  def last_name
  	self.name.split(" ").last
  end

  private

    def check_for_articles
      if articles.count > 0
        errors[:base] << "cannot delete author with existing blog articles"
        return false
      end
    end
end
