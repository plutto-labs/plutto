class SegmentService < PowerTypes::Service.new(:segment)
  def identify(**params)
    return unless report_analytics_active?

    @segment.identify(**params)
  end

  def track(**params)
    return unless report_analytics_active?

    @segment.track(**params)
  end

  def page(**params)
    return unless report_analytics_active?

    @segment.page(**params)
  end

  def group(**params)
    return unless report_analytics_active?

    @segment.group(**params)
  end

  def alias(**params)
    return unless report_analytics_active?

    @segment.alias(**params)
  end

  def flush
    return unless report_analytics_active?

    @segment.flush
  end

  private

  def report_analytics_active?
    ENV.fetch('REPORT_ANALYTICS', false) == 'true'
  end
end
