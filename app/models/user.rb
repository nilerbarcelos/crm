class User < ActiveRecord::Base

  KIND_OPTIONS = %w(administrator user)

  has_many :contracts, :foreign_key => 'leader_id', :dependent => :delete_all
  has_many :tasks, :foreign_key => 'owner_id', :dependent => :delete_all
 
  validates_presence_of :name
  validates_presence_of :login
  validates_presence_of :password, :on => :create
  validates_length_of :login, :within => 5..16
  validates_length_of :password, :within => 5..255
  validates_inclusion_of :kind, :in =>  KIND_OPTIONS

  validates_confirmation_of :password


  def update_attributes(attributes)
    self.attributes = attributes.reject{ |att| (att[0] == "password" && att[1].blank?) }
    save
  end

end
