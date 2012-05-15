class Event < ActiveRecord::Base
  has_many :projects
  has_many :award_categories

  has_many :awards, :through => :award_categories
  has_many :award_winners, :through => :awards, :source => :project

  before_validation :create_slug, :unless => :slug_present?

  accepts_nested_attributes_for :award_categories, :allow_destroy => true, :reject_if => :all_blank

  validates :title, :slug, :presence => true
  validates :slug, :uniqueness => { :case_sensitive => false }

  def to_param
    self.slug
  end

  def winners
    self.award_categories.all.map {|i| i.award_winners.all }.flatten.uniq
  end

  def has_secret?
    !self.secret.nil?
  end

  private
    def slug_present?
      ! self.slug.blank?
    end

    def create_slug
      existing_slugs = Event.all.select {|a| a.slug.match(/^#{self.title.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.title.parameterize}-#{existing_slugs+1}" : self.title.parameterize)
    end
end
