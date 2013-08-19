require "json"

class EventImporter

  class DuplicateSlug < StandardError; end
  class FileNotFound < StandardError; end

  def initialize(path_to_file)
    raise(FileNotFound, "Not found: #{path_to_file}") unless File.exists?(path_to_file)

    @source = JSON.parse( File.open(path_to_file).read )
  end

  def run
    check_for_duplicate_slug!

    @event = Event.create! filtered_event_attributes(@source).merge(:enable_project_creation => true)

    create_award_categories_for_event(@event, @source['award_categories'])
    create_centres_for_event(@event, @source['centres']) if @source['centres']
    create_projects_for_event(@event, @source['projects'])

    @event.update_attribute(:enable_project_creation, false) unless @source["enable_project_creation"]
  end

private
  def check_for_duplicate_slug!
    raise(DuplicateSlug, "Duplicate slug: #{@source['slug']}") if Event.find_by_slug(@source['slug']).present?
  end

  def create_award_categories_for_event(event, categories)
    categories.each do |atts|
      event.award_categories.create! filtered_award_category_attributes(atts)
    end
  end

  def create_centres_for_event(event, centres)
    centres.each do |atts|
      event.centres.create! filtered_centre_attributes(atts)
    end
  end

  def create_projects_for_event(event, projects)
    projects.each do |atts|
      filtered_atts = filtered_project_attributes(atts).merge(:my_secret => event.secret)

      project = event.projects.build filtered_atts
      project.managing = true

      set_centre_for_project!(event, project, atts) if event.use_centres
      project.save!

      award_categories_to_project!(event, project, atts['awards']) if atts['awards'].size > 0
    end
  end

  def set_centre_for_project!(event, project, atts)
    centre_slug = @source["centres"].find {|c| c["id"] == atts["centre_id"] }["slug"]
    if centre_slug
      project.centre = event.centres.find_by_slug(centre_slug)
    end
  end

  def award_categories_to_project!(event, project, atts)
    # this relies on award category titles being unique :(
    atts.each do |award|
      category_title = @source["award_categories"].find {|a| a["id"] == award["award_category_id"] }["title"]
      event.award_categories.find_by_title(category_title).award_to(project)
    end
  end

  def filtered_event_attributes(atts)
    atts.symbolize_keys.slice(:title, :slug, :hashtag, :secret, :active, :use_centres, :url, :start_date)
  end

  def filtered_award_category_attributes(atts)
    atts.symbolize_keys.slice(:title, :description, :format, :featured, :level)
  end

  def filtered_centre_attributes(atts)
    atts.symbolize_keys.slice(:name, :slug)
  end

  def filtered_project_attributes(atts)
    atts.symbolize_keys.slice(:title, :slug, :team, :summary, :description, :twitter, :url, :code_url, :svn_url, :data, :code, :ideas,
                                :github_url, :secret, :image_file_name, :image_file_size, :image_content_type, :image_updated_at)
  end
end
