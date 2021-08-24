SEGMENT_WRITE_KEY = ENV.fetch('SEGMENT_RUBY_WRITE_KEY')

Analytics = Segment::Analytics.new(
  write_key: SEGMENT_WRITE_KEY,
  on_error: Proc.new { |_, msg| print msg }
)
