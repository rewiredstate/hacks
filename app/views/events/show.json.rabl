object @event

attribute :title, :hashtag
code(:url) {|e| event_url(e)}

child :projects do
  attributes :title, :team, :summary

  if @event.use_centres
    code(:centre) {|p| p.centre.slug }
  end

  code(:url) {|p| event_project_url(@event, p)}
  code(:awarded) {|p| p.has_won_award? }

  child :award_categories => :awards do
    attribute :title, :description
  end
end

child :centres do
  attributes :name
  code(:url) {|c| centre_event_url(@event, c.slug) }
  code(:count) {|c| c.projects.count }
end
