class Event < ActiveRecord::Base  
  has_many :projects
  has_many :award_categories                     
  
  has_many :awards, :through => :award_categories
  has_many :award_winners, :through => :awards, :source => :project 
  
  before_validation :create_slug
             
  validates :title, :slug, :presence => true       
  validates :slug, :uniqueness => { :case_sensitive => false }
                                               
  def to_param
    self.slug
  end       
  
  def has_secret?
    !self.secret.nil?
  end
  
  private
    def create_slug
      self.slug = self.title.parameterize unless self.slug
    end                                        
end
