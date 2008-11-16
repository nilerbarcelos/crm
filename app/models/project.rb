class Project < ActiveRecord::Base

   belongs_to :customer
   
   has_many :contracts, :dependent => :delete_all
   has_many :tasks, :dependent => :delete_all
   has_many :implementors, :through => :tasks, :source => :owner

   has_and_belongs_to_many :members, :class_name => "User",
     :join_table => "projects_members",
     :association_foreign_key => "member_id"

   has_many :documents, :as => :archivable, :dependent => :delete_all

   has_attached_file :photo, :styles => {:small =>"100x100>", :very_small =>"50x50>"},
			:url =>	 "/assets/projects/:id/:style/:basename.:extension",
			:path => ":rails_root/public/assets/projects/:id/:style/:basename.:extension"
   
   validates_attachment_presence :photo
   validates_attachment_size :photo, :less_than => 5.megabytes
   validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png' ]

   named_scope :actives, :conditions => {:active => true} 
   named_scope :inactives, :conditions => {:active => false}


   validates_presence_of :name
   validates_uniqueness_of :name
   validates_presence_of :customer_id
   
  #def photo=(p)
   #self[:photo] = p unless p.blank?
  #end
end
