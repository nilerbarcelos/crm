class HomeController < ApplicationController
  before_filter :load_items

  skip_before_filter :authenticate, :only => [:set_language]

  def set_language
    expire_fragment :controller => "customer", :action => "index", :id => session[:user]
#    puts "Ola"
    session[:locate] = params[:locate]
    redirect_to :back
  end

  def index
    @incomplete_tasks = current_user.tasks.with_status :open
    @completed_tasks = current_user.tasks.with_status :closed
  end

  def finish
    @task = current_user.tasks.find(params[:id].gsub(/\D/, ""))
    #@task = current_user.tasks.find(params[:id])
    @task.update_attribute("status", "closed")
    respond_to do |format|
      format.js
      format.html {redirect_to root_url}
    end
  end

  def save 
    @task = Task.new(params[:task].merge({ :status => "open" })) 
    @task.owner = current_user 
    @task.save 
    respond_to do |format|
      format.js
      format.html do
        if @task.valid?
         redirect_to root_url
        else
         redirect_to_index
        end
      end
    end
  end


  def edit
    @task = current_user.tasks.find(params[:id])
    respond_to do |format|
      format.js
      format.html {redirect_to_index}
    end
  end


  # PUT /users/1
  # PUT /users/1.xml
  def update
    @task = current_user.tasks.find(params[:id])
      respond_to do |format| 
        if @task.update_attributes(params[:task])
          flash[:notice] = 'Task was successfully updated.'
		format.js
		format.html {redirect_to root_url}
        else
          redirect_to_index
        end
      end
  end

  protected
  def  load_items
    @projects = Project.find(:all).collect {|p| [p.name, p.id]}
  end

  private
  def redirect_to_index
      index
      render :action => "index"
  end
end

