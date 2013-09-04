# Authorable associates one or more authors to one or more articles.
class Authorable < ActiveRecord::Base
  belongs_to :author
  belongs_to :article, touch: true
end
