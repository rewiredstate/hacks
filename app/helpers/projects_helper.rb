module ProjectsHelper
  def twitter_links_for(project)
    output = []
    project.twitter.split(/, ?/).take(4).each do |t| 
      clean_user = sanitize t.strip.sub('@','')
      output << link_to("@#{clean_user}", "http://twitter.com/#{clean_user}") 
    end
    output.join(', ').html_safe
  end           
  
  def no_picture_message
    ['A picture is worth a thousand words.','Every picture tells a story.'].sample
  end
end
