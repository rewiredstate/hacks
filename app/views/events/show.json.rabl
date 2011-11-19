object @event                                                                                                     

attribute :title, :hashtag
code(:url) {|e| event_url(e)}      

child :projects do
  attributes :title, :team, :summary
  code(:url) {|p| event_project_url(@event, p)} 
  code(:awarded) {|p| p.has_won_award? }        
  
  child :award_categories => :awards do
    attribute :title, :description
  end
end