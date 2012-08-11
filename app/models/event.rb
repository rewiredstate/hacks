class Event < ActiveRecord::Base
  has_many :projects
  has_many :award_categories
  has_many :centres

  has_many :awards, :through => :award_categories
  has_many :award_winners, :through => :awards, :source => :project

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.title.blank? }

  accepts_nested_attributes_for :award_categories, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :centres, :reject_if => :all_blank

  validates :title, :slug, :presence => true
  validates :slug, :uniqueness => { :case_sensitive => false }

  def to_param
    self.slug
  end

  def winners
    self.award_categories.featured.all.map {|i| i.award_winners.all }.flatten.uniq
  end

  def has_secret?
    !self.secret.blank?
  end

  private
    def create_slug
      existing_slugs = Event.all.select {|a| a.slug.match(/^#{self.title.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.title.parameterize}-#{existing_slugs+1}" : self.title.parameterize)
    end
end
