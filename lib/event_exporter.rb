class EventExporter
  def initialize(event)
    @event = event
  end

  def to_json
    @event.to_json(
      :include => {
        :award_categories => {},
        :centres => {},
        :projects => {
          :include => :awards
        }
      }
    )
  end
end
