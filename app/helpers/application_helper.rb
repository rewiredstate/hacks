module ApplicationHelper
  
  def mkdn(string) 
    RDiscount.new(string).to_html.html_safe
  end
  
end
