module ProjectsHelper
  GITHUB_URL_MATCH = %r{//(www\.)?github.com/(([A-Za-z0-9_-]+)(/[A-Za-z0-9_-]+)?)}i

  def twitter_links_for(project)
    output = []
    project.twitter.split(/, ?/).take(8).each do |t| 
      clean_user = sanitize t.strip.sub('@','')
      output << link_to("@#{clean_user}", "http://twitter.com/#{clean_user}") 
    end
    output.join(', ').html_safe
  end           
  
  def no_picture_message
    ['A picture is worth a thousand words.','Every picture tells a story.'].sample
  end

  def format_github_url(url)
    url.match(GITHUB_URL_MATCH) do |m|
      return m[2]
    end
    return url
  end
end
