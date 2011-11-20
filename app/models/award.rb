class Award < ActiveRecord::Base
  belongs_to :project
  belongs_to :award_category
  
  default_scope order('award_categories.format DESC, award_categories.level ASC')
end                       