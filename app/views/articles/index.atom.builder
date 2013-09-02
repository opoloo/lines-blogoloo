atom_feed do |feed|
  feed.title "Squirrel Park - Opoloo's Blog"
  feed.updated @articles.maximum(:updated_at)
  feed.logo "http://blog.opoloo.com/assets/opoloo_feed.png" # aspect ratio should be 2:1
  feed.icon "http://blog.opoloo.com/favivon.ico" # aspect ratio should be 1:1

  @articles.each do |article|
    feed.entry article, url: article_url(article), published: article.published_at do |entry|
      entry.title article.title
      entry.summary type: 'xhtml' do |xhtml|
        xhtml << (article.teaser.blank? ? simple_format(
            truncate(
              Sanitize.clean(
                markdown(article.content)
              ), length: 300, separator: ' ', omission: ' ...'
            )
          ) : markdown(article.teaser).html_safe)
      end
      entry.content type: 'xhtml' do |xhtml|
        xhtml << (article.is_short_article? ? '' : content_tag(:p,"<img src=\"#{article.image_url}\" alt=\"#{article.title}\"/>".html_safe).html_safe )
        xhtml << markdown(article.content).html_safe
      end
      entry.author do |author|
        article.authors.each do |a|
          author.name a.name
        end
      end
      entry.contributor do |author|
        article.authors.each do |a|
          author.name a.name
        end
      end
    end
  end
end