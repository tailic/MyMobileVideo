class ArticlesController < ApplicationController
   load_and_authorize_resource
  respond_to :json

  
  def index
    @articles = Article.all
    @featured_articles = Article.where(:exclusive => true).limit(2).order("articles.updated_at DESC")
    respond_to do |format|
      format.html # new.html.haml
      format.json { render :partial => 'articles/index.json'} 
    end
  end

  def show
    @article = Article.find(params[:id])
    @articles = Article.all(:limit => 3)
    @article.views = @article.views + 1
    @article.save
    asdf = @article.tags.clone
    @releated = asdf.map!{|tag| tag.articles}.flatten.uniq
    respond_to do |format|
      format.html # show.html.haml
      format.json  { render :partial => 'articles/show.json' }
    end
  end
  
  def search 
    @search = params[:search]
    @articles = Article.search @search
    respond_to do |format|
      format.html 
      format.json  { render :partial => 'articles/index.json' }
    end
  end

  def new
    @article = Article.new
    unauthorized! if cannot? :create, @article
    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :partial => 'articles/show.json' }
    end
  end

  def edit
    @article = Article.find(params[:id])
    unauthorized! if cannot? :edit, @article
  end

  def create
    @article = Article.new(params[:article])
    unauthorized! if cannot? :create, @article
    @article.user = current_user
    @article.views = 0
    respond_to do |format|
      if @article.save
        @article.delay.convert
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.json  { render :json => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
  def vote 
    vote =Vote.find_by_article_id_and_user_id(params[:article_id],current_user.id)
    if vote
      vote.value = params[:vote]
    else
      vote = Vote.create(:article_id => params[:article_id],:value => params[:vote])
      vote.user = current_user
    end
    vote.save
    redirect_to(Article.find(params[:article_id]))
  end
  
  def create_comment 
    comment = Comment.create(:text => params[:text])
    comment.user = current_user
    art = Article.find(params[:article_id])
    comment.article = art
    comment.save
    redirect_to(art)
  end  

  
end
