require "event_exporter"
require "event_importer"

def logger
  @logger ||= Logger.new(STDOUT)
end

namespace :events do
  desc "export an event, along with projects, awards and centres, to JSON"
  task :export, [:slug] => :environment do |t,args|
    event = Event.find_by_slug(args[:slug])
    unless event.present?
      logger.error "No event found with slug #{args[:slug]}"
      exit
    end

    logger.info "Found event #{event.title}"
    export = EventExporter.new(event)
    puts export.to_json
  end

  desc "import an event from a JSON file"
  task :import, [:file_path] => :environment do |t,args|
    importer = EventImporter.new(args[:file_path])
    importer.run
  end  
end
