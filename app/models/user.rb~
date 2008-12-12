class User < ActiveRecord::Base

  cattr_accessor :current_user_id
  #attr_protected :password


  KIND_OPTIONS = %w(administrator user)

  has_many :contracts, :foreign_key => 'leader_id', :dependent => :delete_all
  has_many :tasks, :foreign_key => 'owner_id', :dependent => :delete_all
 
  has_many :documents, :as => :archivable, :dependent => :delete_all
 
  validates_presence_of :name
  validates_presence_of :login
  validates_presence_of :password, :on => :create
  validates_length_of :login, :within => 5..16
  validates_length_of :password, :within => 5..255
  validates_inclusion_of :kind, :in =>  KIND_OPTIONS

  validates_confirmation_of :password


  def password=(p)
   self[:password] = p unless p.blank?
  end

end
