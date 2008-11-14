class Task < ActiveRecord::Base
  STATUS_OPTIONS = %w(open closed)
  PRIORITY_OPTIONS = %w(normal low high)

  belongs_to :owner, :class_name => 'User'
  belongs_to :project

  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :owner_id
  validates_presence_of :project_id
  validates_numericality_of :progress, :only_integer => true, :allow_nil => true
  validates_inclusion_of :status, :in => %w(open closed)
  validates_inclusion_of :priority, :in => %w(normal low high)


  named_scope :with_status, lambda { |s| 
  	{ :conditions => { :status => s.to_s } }
  	} 


  after_create :register_create
  after_update :register_update

  def register_create
	My_Log::Log.create(:message => "Task: #{self.title} created by #{self.owner.name}")
  end

  def register_update
	My_Log::Log.create(:message => "Task #{self.title} updated by #{self.owner.name} ")
  end 
  
  class << self

   def find_high(options = {})
     with_priority("high") do
       find(:all, options)
     end
   end
   
   def find_low(options = {})
     with_priority("low") do
       find(:all, options)
     end
   end
   
  def find_normal(options = {})
    with_priority("normal") do
      find(:all, options)
    end
  end

  def with_priority(priority)
    with_scope(:find => {:conditions => {:priority => priority}}) do
      yield
    end
   end
  end

end
