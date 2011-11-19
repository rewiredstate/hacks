class Project < ActiveRecord::Base
  belongs_to :event                      
  
  default_scope order('title ASC')
  
  has_many :awards
  has_many :award_categories, :class_name => 'AwardCategory', :through => :awards
  
  has_attached_file :image, 
    :styles => { :full => ["1080x640#", :jpg], :project => ["540x320#", :jpg], :mini => ["270x160#", :jpg] },
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }           
  before_post_process :set_filename                               
  
  attr_accessor :my_secret
  
  before_validation :create_slug
       
  validates :title, :team, :description, :url, :presence => true            
  validates :slug, :uniqueness => { :case_sensitive => false }      
  validates :secret, :presence => true, :on => :create, :if => :secret_required?   
  
  validates_each :my_secret, :on => :create, :if => :event_secret_required? do |model, attr, value|
    model.errors.add(attr, 'is incorrect') if (value != model.event.secret)
  end
  validates_each :my_secret, :on => :update do |model, attr, value|
    if model.secret_required?
      model.errors.add(attr, 'is incorrect') if (value != model.secret)
    else # event secret required
      model.errors.add(attr, 'is incorrect') if (value != model.event.secret) 
    end
  end
       
  def to_param
    self.slug
  end                    
  
  def event_secret_required?
    self.event.has_secret?
  end
  
  def secret_required?
    !self.event.has_secret?
  end
                          
  def format_url(url)
    url.match(/http:\/\/(.*)/i)[1].sub(/\/$/i,'')
  end
  
  def formatted_github_url
    self.github_url.match(/\/([A-Za-z0-9_-]+\/[A-Za-z0-9_-]+)/i)[1]
  end                               
                    
  def set_filename
    self.slug + Time.now.strftime('%s')
  end
  
  def has_won_prize?
    (self.awards.count > 0) ? true : false
  end
  
  private
    def create_slug
      self.slug = self.title.parameterize if !self.slug or self.slug.empty?
    end
end
