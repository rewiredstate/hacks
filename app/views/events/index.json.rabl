collection events

attributes :title, :hashtag

code(:url) {|e| event_url(e)}
code(:projects_count) {|e| e.projects.count }
