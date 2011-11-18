module ProjectsHelper
  def twitter_links_for(project)
    output = []
    project.twitter.split(/, ?/).take(4).each do |t| 
      clean_user = sanitize t.strip.sub('@','')
      output << link_to("@#{clean_user}", "http://twitter.com/#{clean_user}") 
    end
    output.join(', ').html_safe
  end
end
