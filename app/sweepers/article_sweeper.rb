class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article

  def sweep(article)
    expire_page articles_path
    expire_page article_path(article)
    expire_page "/"
    FileUtils.rm_rf "#{page_cache_directory}/articles/page"
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end