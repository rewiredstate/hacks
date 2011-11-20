class Project < ActiveRecord::Base
  belongs_to :event                      
                                 
  has_paper_trail
  
  default_scope order('title ASC')
  after_initialize :set_default_values                            
  
  has_many :awards
  has_many :award_categories, :class_name => 'AwardCategory', :through => :awards 
  
  has_attached_file :image, 
    :styles => { :full => ["1080x640#", :jpg], :project => ["540x320#", :jpg], :mini => ["270x160#", :jpg], :thumb => ["140x83#", :jpg] },
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }                                                             
  
  attr_accessor :my_secret
  
  before_validation :create_slug, :blank_url_fields
       
  validates :title, :team, :description, :presence => true
  validates :summary, :presence => true, :length => { :maximum => 180 }          
  validates :slug, :uniqueness => { :case_sensitive => false }      
  validates :secret, :presence => true, :on => :create, :if => :secret_required?   
  validates :url, :code_url, :github_url, :svn_url, :format => { :with => URI::regexp, :allow_blank => true }
  
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
  
  def has_won_award?
    (self.awards.count > 0) ? true : false
  end
  
  private
    def create_slug
      self.slug = self.title.parameterize if !self.slug or self.slug.empty?
    end            
                           
    def blank_url_fields
      self.url = '' if self.url == 'http://'
      self.github_url = '' if self.github_url == 'http://'
      self.code_url = '' if self.code_url == 'http://'
      self.svn_url = '' if self.svn_url == 'http://'
    end
    
    def set_default_values
      self.url ||= 'http://'
      self.github_url ||= 'http://' 
      self.svn_url ||= 'http://'
      self.code_url ||= 'http://'   
    end
end
