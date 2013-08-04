require "event_exporter"

def logger
  @logger ||= Logger.new(STDOUT)
end

namespace :events do
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
end
