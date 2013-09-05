# Lists all Articles and shows specific ones.
# Responds either to HTML and ATOM requests.
class ArticlesController < ApplicationController

  layout 'application'

  KEYWORDS = CONFIG[:keywords]
  SITE_TITLE = CONFIG[:title]

  # Lists all published articles.
  # Responds to html and atom
  def index
    respond_to do |format|
      format.html {
        @first_page = (params[:page] and params[:page].to_i > 0) ? false : true
        if params[:tag]
          @articles = Article.published.tagged_with(params[:tag]).page(params[:page].to_i)
        else
          @articles = Article.published.page(params[:page].to_i).padding(1)
        end
        @first_article = Article.published.first if @articles.first_page?
        set_meta_tags title: SITE_TITLE,
                      description: CONFIG[:meta_description],
                      keywords: KEYWORDS,
                      open_graph: { title: SITE_TITLE,
                                      type: 'website',
                                      url: 'meta_og_url',
                                      site_name: SITE_TITLE,
                                      image: CONFIG[:og_logo]
                                    }

      }
      format.atom{
        @articles = Article.published
      }
    end
  end

  # Shows specific article
  def show
    @first_page = true
    @article = Article.published.find(params[:id])
    set_meta_tags title: @article.title,
                  keywords: KEYWORDS + @article.tag_list.to_s,
                  open_graph: { title: SITE_TITLE,
                                   type: 'article',
                                   url: 'meta_og_url',
                                   site_name: SITE_TITLE,
                                   image: CONFIG[:host] + @article.image_url
                                 }
    if request.path != article_path(@article)
      return redirect_to @article, status: :moved_permanently
    end
  end

end
