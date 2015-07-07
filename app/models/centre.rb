class Centre < ActiveRecord::Base
  belongs_to :event
  has_many :projects

  default_scope -> { order('name ASC') }

  validates :name, :slug, :presence => true
  validates :slug, :uniqueness => { :case_sensitive => false, :scope => :event_id }

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.name.blank? }

  private
    def create_slug
      existing_slugs = event.centres.select {|a| a.slug.match(/^#{self.name.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.name.parameterize}-#{existing_slugs+1}" : self.name.parameterize)
    end
end
