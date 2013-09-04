class Admin::ArticlesController < Admin::ApplicationController

  autocomplete :tag, :name, class_name: 'ActsAsTaggableOn::Tag'
  before_filter :process_base64_upload, only: [:create, :update]

  def index
    @articles = Article.order('published ASC, featured DESC, published_at DESC').page(params[:page]).per(25)
    @articles_unpublished = @articles.select{|a| a.published == false}
    @articles_published = @articles.select{|a| a.published == true}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @first_page = true

    respond_to do |format|
      format.html {render :show, layout: 'application'}
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_article_path(@article), notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    article_params = params[:article]

    #replace picture_path with the new uploaded file
    article_params[:hero_image] = @uploaded_file if @uploaded_file

    if params[:commit] == "Save & publish"
      article_params[:published] = true
    end
    if params[:commit] == "Save & unpublish"
      article_params[:published] = false
    end

    # delete uploaded hero image when predifined image is selected
    if !article_params[:hero_image_cache].present? && article_params[:short_hero_image].present?
      @article.remove_hero_image! 
      @article.remove_hero_image = true 
      @article.save
    end

    respond_to do |format|
      if @article.update_attributes(article_params)
        ActionController::Base.new.expire_fragment(@article)
        format.html { redirect_to admin_article_path(@article), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.json { head :no_content }
    end
  end

  def preview
    @article = Article.new(params[:article])
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
    @article = Article.find(params[:article_id])
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

  def process_base64_upload
    @uploaded_file = nil
    #check if file is given
    if params[:article][:hero_image_file] != ""

      picture_filename = "hero_image"
      picture_original_filename = "hero_image"
      picture_content_type = splitBase64(params[:article][:hero_image_file])[:type]
      picture_data = splitBase64(params[:article][:hero_image_file])[:data]

      #create a new tempfile named fileupload
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode

      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(picture_data))

      #create a new uploaded file
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: tempfile, 
        filename: picture_filename,
        original_filename: picture_original_filename
      )
      @uploaded_file.content_type = picture_content_type
    end
  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
        }
    end
  end

end
