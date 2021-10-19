class CustomerAnalyticsService < PowerTypes::Service.new(:customer)
  def meter_events_data
    data = {}
    @customer.meters.pluck(:name, :id).to_a.map do |meter_name, meter_id|
      data[meter_name] = group_by_date(meter_events(meter_id)).maximum(:current_meter_count)
    end

    data
  end

  private

  def group_by_date(records, column = :timestamp, format = '%d-%b', last = 30)
    records.group_by_day(column, last: last, format: format)
  end

  def meter_events(meter_id)
    @customer.meter_events.where(meter_id: meter_id)
  end
end
