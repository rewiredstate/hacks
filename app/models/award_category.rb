class AwardCategory < ActiveRecord::Base                           
  belongs_to :event
  
  default_scope order('format DESC, level ASC')                                                              
  
  has_many :awards
  has_many :award_winners, :through => :awards, :source => :project     
  
  validates :format, :presence => true
  
  def project_action
    case self.format
    when "overall"
      "was awarded"
    when "mention"
      "was given a"
    end
  end
end
