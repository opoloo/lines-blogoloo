class Admin::ShortArticlesController < Admin::ApplicationController

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag'
  #cache_sweeper :article_sweeper

  def index
    #@articles = Article.order('published_at DESC')
    @articles = Article.order('published_at DESC').page(params[:page]).per(25)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = ShortArticle.find(params[:id])
    @first_page = true

    respond_to do |format|
      format.html {render :show, layout: 'application'}
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = ShortArticle.new

    respond_to do |format|
      format.html { render template: '/admin/articles/new'}# new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = ShortArticle.find(params[:id])
    render template: '/admin/articles/edit'
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = ShortArticle.new(params[:short_article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_article_path(@article), notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render 'admin/articles/new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = ShortArticle.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:short_article])
        format.html { redirect_to admin_article_path(@article), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render "admin/articles/edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = ShortArticle.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.json { head :no_content }
    end
  end

  def preview
    @article = ShortArticle.new(params[:article])
    @first_page = true
    respond_to do |format|
      if @article.valid? or true
        format.js
      else
        format.js {render js: 'alert("Form not valid!");'}
      end
    end
  end

  def toggle_publish
    @article = ShortArticle.find(params[:article_id])
    @article.update_attributes(published: !@article.published)
    redirect_to admin_articles_url, notice: 'Article updated!'
  end

  def toggle_feature
    @article = Article.find(params[:article_id])
    old_featured = Article.find_all_by_featured(true)
    if old_featured.size > 0
      old_featured.each do |article|
        article.update_attributes(featured: false)
      end
    end
    @article.update_attributes(featured: !@article.featured)
    redirect_to admin_articles_url, notice: 'Article updated!'
  end

end
