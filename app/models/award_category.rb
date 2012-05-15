class AwardCategory < ActiveRecord::Base
  belongs_to :event

  default_scope order('format DESC, level ASC, title ASC')

  has_many :awards, :dependent => :destroy
  has_many :award_winners, :through => :awards, :source => :project

  validates :title, :presence => true
  validates :level, :presence => true, :numericality => { :only_integer => true }
  validates :format, :presence => true, :inclusion => { :in => ["overall","mention"]}

  def award_to(project)
    self.awards.create :project => project
  end

  def project_action
    case self.format
    when "overall"
      "was awarded"
    when "mention"
      "was given a"
    end
  end
end
