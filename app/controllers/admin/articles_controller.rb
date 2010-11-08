class Admin::ArticlesController < ApplicationController
load_and_authorize_resource
layout 'admin'
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  def show
    @article = Article.find(params[:id])
    @articles = Article.all(:limit => 5)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def new
    @article = Article.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        @article.convert
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      
       if @article.update_attributes(params[:article])
      flash[:notice] = "Successfully updated Video."
      redirect_to admin_articles_path
    else
      render :action => 'editarticle'
    end
    end
  end
  
  
   def destroy
    @article = Article.find(params[:id])
    if @article.delete
      flash[:notice] = "Successfully deleted Article."
      redirect_to admin_articles_path
    end
  end

end
