class Project < ActiveRecord::Base
  belongs_to :event
  belongs_to :centre
  include Manageable

  has_paper_trail

  default_scope order('title ASC')
  after_initialize :set_default_values

  has_many :awards
  has_many :award_categories, :class_name => 'AwardCategory', :through => :awards

  attr_accessible :title, :team, :url, :secret, :my_secret, :image, :summary, :description, :ideas, :data, :twitter, :github_url, :svn_url, :code_url, :centre, :centre_id
  attr_accessible :title, :team, :url, :secret, :image, :summary, :description, :ideas, :data, :twitter, :github_url, :svn_url, :code_url, :awards_attributes, :centre, :centre_id, :slug, :as => :admin

  accepts_nested_attributes_for :awards, :reject_if => :all_blank, :allow_destroy => true

  has_attached_file( :image, Rails.application.config.attachment_settings.merge({
    :styles => {
      :full => ["1080x640#", :jpg],
      :project => ["540x320#", :jpg],
      :mini => ["270x160#", :jpg],
      :thumb => ["140x83#", :jpg]
    }
  }) )

  comma do
    title "Project Name"
    team "Team"
    summary "Description"
    project_url
    url "URL"
    notes
  end

  attr_accessor :my_secret

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.title.blank? }
  before_validation :blank_url_fields

  validates :title, :team, :description, :presence => true
  validates :summary, :presence => true, :length => { :maximum => 180 }
  validates :slug, :uniqueness => { :case_sensitive => false }
  validates :secret, :presence => true, :on => :create, :if => :secret_required?
  validates :url, :code_url, :github_url, :svn_url, :format => { :with => URI::regexp, :allow_blank => true }
  validates :centre, :presence => true, :if => proc { |a| a.event.use_centres == true }
  validate :ensure_project_creation_is_enabled

  validates_attachment_presence :image, :on => :create
  validates_attachment_size :image, :less_than=>1.megabyte, :if => Proc.new { |i| !i.image.file? }

  with_options :unless => :managing do |o|
    o.validates_each :my_secret, :on => :create, :if => :event_secret_required? do |model, attr, value|
      model.errors.add(attr, "is incorrect") if (value != model.event.secret)
    end
    o.validates_each :my_secret, :on => :update do |model, attr, value|
      model.errors.add(attr, 'is incorrect') if (value != model.project_or_event_secret)
    end
  end

  def to_param
    self.slug
  end

  def event_secret_required?
    self.event.has_secret?
  end

  def secret_required?
    ! self.event_secret_required?
  end

  def project_or_event_secret
    self.event_secret_required? ? self.event.secret : self.secret
  end

  def format_url(url)
    url_parts = url.match(/https?:\/\/(.*)/i)
    url_parts ? url_parts[1].sub(/\/$/i,'') : url
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

  def notes
  ""
  end

  def project_url
    "http://hacks.rewiredstate.org" + Rails.application.routes.url_helpers.event_project_path(self.event, self)
  end

  private
    def create_slug
      existing_slugs = Project.all.select {|a| a.slug.match(/^#{self.title.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.title.parameterize}-#{existing_slugs+1}" : self.title.parameterize)
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

    def ensure_project_creation_is_enabled
      unless event.enable_project_creation
        errors.add(:event, "no longer allows projects to be created")
      end
    end
end
