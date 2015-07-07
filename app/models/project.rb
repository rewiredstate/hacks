class Project < ActiveRecord::Base
  belongs_to :event
  belongs_to :centre

  has_paper_trail

  default_scope -> { order('title ASC') }
  after_initialize :set_default_values

  has_many :awards
  has_many :award_categories, :class_name => 'AwardCategory', :through => :awards

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

  attr_accessor :submitted_secret

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.title.blank? }
  before_validation :blank_url_fields

  validates :title, :team, :description, :presence => true
  validates :summary, :presence => true, :length => { :maximum => 180 }
  validates :slug, :uniqueness => { :case_sensitive => false }
  validates :secret, :presence => true, :on => :create
  validates :url, :code_url, :github_url, :svn_url, :format => { :with => URI::regexp, :allow_blank => true }
  validates :centre, :presence => true, :if => proc { |a| a.event.use_centres == true }
  validate :ensure_project_creation_is_enabled, :on => :create

  validates_attachment :image, presence: true,
                               content_type: {
                                 content_type: ["image/jpeg", "image/gif", "image/png"]
                               },
                               size: {
                                 less_than: 1.megabyte,
                               }

  def update_attributes_with_secret(submitted_secret, attributes)
    if valid_secret?(submitted_secret)
      update_attributes(attributes)
    else
      self.errors.add(:secret, 'is not correct')
      return false
    end
  end

  def to_param
    self.slug
  end

  def format_url(url)
    url_parts = url.match(/https?:\/\/(.*)/i)
    url_parts ? url_parts[1].sub(/\/$/i,'') : url
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

    def valid_secret?(submitted_secret)
      submitted_secret.present? &&
        submitted_secret == secret
    end
end
