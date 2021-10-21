METER_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: 'event_80b199c7744342f3c5df8622', 'x-nullable': false },
    name: { type: :string, example: 'Some meter', 'x-nullable': false }
  },
  required: [
    :name
  ]
}
