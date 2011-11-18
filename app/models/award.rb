class Award < ActiveRecord::Base
  belongs_to :project
  belongs_to :award_category
end                       