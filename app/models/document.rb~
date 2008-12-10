class Document < ActiveRecord::Base

   belongs_to :user, :polymorphic => true
   belongs_to :project, :polymorphic => true

   validates_presence_of :title
  
   has_attached_file :doc ,
		:url => "/archive/:class/:archivable_type/:archivable_id/:attachment/:id/:basename.:extension",
	:path => ":rails_root/public/archive/:class/:archivable_type/:archivable_id/:attachment/:id/:basename.:extension"

   validates_attachment_presence :doc
   validates_attachment_size :doc, :less_than => 5.megabytes
   #validates_attachment_content_type :doc, :content_type => ['application/pdf', 'application/doc' ]

   Paperclip::Attachment.interpolations[:archivable_id] = proc do |attachment, style|
      attachment.instance.archivable_id
   end
   
   Paperclip::Attachment.interpolations[:archivable_type] = proc do |attachment, style|
      attachment.instance.archivable_type.downcase
   end
end
