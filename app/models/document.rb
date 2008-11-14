class Document < ActiveRecord::Base

   belongs_to :project

   validates_presence_of :title
  
   has_attached_file :doc ,
			:url => "/archive/projects/:class/:attachment/:basename.:extension",
			:path => ":rails_root/public/archive/projects/:class/:attachment/:basename.:extension"


   validates_attachment_presence :doc
   validates_attachment_size :doc, :less_than => 5.megabytes
   #validates_attachment_content_type :doc, :content_type => ['image/pdf', 'image/doc' ]


end
