class AwardCategory < ActiveRecord::Base                           
  belongs_to :event
  
  has_many :awards
  has_many :award_winners, :through => :awards, :source => :project
end
