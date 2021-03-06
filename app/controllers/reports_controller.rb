class ReportsController < ApplicationController


  def a4
   respond_to do |format|
    format.pdf #{ render :layout => false }
   end
  end

  def customers_in_pdf
   @customers = Customer.find :all
   respond_to do |format|
    format.pdf  #{ render :layout => false }
   end
  end

  def list_immediate_action_required
	  @tasks = Task.find_high(:order => "title")
  end

  def send_from_disk
  # Process request and create file in disk
  send_file 'protected_files/CacheFormatos.pdf', :filename => "CacheFormatos.pdf",
    :type => "application/pdf", :disposition => "attachment"
  end

end
