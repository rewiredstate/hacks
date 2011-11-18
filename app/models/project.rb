class Project < ActiveRecord::Base
  belongs_to :event
  
  has_many :awards
  has_many :prizes, :class_name => 'AwardCategory'
  
  before_validation :create_slug
       
  validates :title, :slug, :team, :description, :presence => true            
  validates :slug, :uniqueness => { :case_sensitive => false }
       
  def to_param
    self.slug
  end             
                          
  def format_url(url)
    url.match(/http:\/\/(.*)/i)[1].sub(/\/$/i,'')
  end
  
  def formatted_github_url
    self.github_url.match(/\/([A-Za-z0-9_-]+\/[A-Z-az0-9_-]+)/i)[1]
  end                               
  
  private
    def create_slug
      slug = title.parameterize
    end
end
