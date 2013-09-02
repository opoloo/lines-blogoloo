class ChangeTeaserToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :teaser, :text
  end
end
