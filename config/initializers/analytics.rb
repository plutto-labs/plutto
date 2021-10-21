SEGMENT_WRITE_KEY =
  ENV.fetch('REPORT_ANALYTICS', false) == 'true' ? ENV.fetch('SEGMENT_RUBY_WRITE_KEY') : ''

Rails.application.reloader.to_prepare do
  segment = Segment::Analytics.new(
    write_key: SEGMENT_WRITE_KEY,
    on_error: Proc.new { |_, msg| logger.error(msg) }
  )

  ::Analytics = SegmentService.new(segment: segment)
end
