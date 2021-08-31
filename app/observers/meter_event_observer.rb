class MeterEventObserver < PowerTypes::Observer
  before_save :update_meter_count

  def update_meter_count
    object.meter_count.update_count(object)
    object.current_meter_count = object.meter_count.count
  end
end
