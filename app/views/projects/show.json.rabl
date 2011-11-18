object @project

attributes :title, :team, :data, :ideas, :costs, :twitter, :github_url, :svn_url, :code_url 
attribute :url => :project_url

code(:url) {event_project_url(@event, @project)}
                                                    
child :event do        
  attribute :title
  code(:url) {|e| event_url(e)}
end