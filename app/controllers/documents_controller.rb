class DocumentsController < ApplicationController

  parent_resources :project, :user

  before_filter :load_project

  # GET /documents
  # GET /documents.xml
  def index
    @documents = @parent.documents.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = @parent.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = @parent.documents.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = @parent.documents.find(params[:id])
  end

  # POST /documents
  # POST /documents.xml
  def create
    @document = @parent.documents.new(params[:document])
    respond_to do |format|
      if @document.save
        flash[:notice] = 'Document was successfully created.'
        format.html { redirect_to([@parent, @document]) }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        @document.errors.each {|t| puts t}
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @document = @parent.documents.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        flash[:notice] = 'Document was successfully updated.'
        format.html { redirect_to([@parent, @document]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = @parent.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to([@parent, :documents]) }
      format.xml  { head :ok }
    end
  end

  protected
  def load_project
    @parent =  parent_object
    #Project.find(params[:project_id], :include => :documents)
  end
end
