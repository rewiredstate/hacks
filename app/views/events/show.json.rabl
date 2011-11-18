object @event                                                                                                     

attribute :title, :hashtag
code(:url) {|e| event_url(e)}      

child :projects do
  attributes :title, :team, :description
  code(:url) {|p| event_project_url(@event, p)} 
  code(:awarded) {|p| p.has_won_prize? }        
  
  child :award_categories => :awards do
    attribute :title, :description
  end
end