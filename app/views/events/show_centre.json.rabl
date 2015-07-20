object @centre

attribute :name
code(:url) {|e| centre_event_url(event, @centre.slug)}

child :projects do
  attributes :title, :team, :summary

  if event.use_centres
    code(:centre) {|p| p.centre.slug }
  end

  code(:url) {|p| event_project_url(event, p)}
  code(:awarded) {|p| p.has_won_award? }

  child :award_categories => :awards do
    attribute :title, :description
  end
end
