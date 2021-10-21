PERMISSION_GROUP_SCHEMA = {
  type: :object,
  properties: {
    id: {
      type: :string, example: 'permission_group_d4328039347671a0b4b07f3f', 'x-nullable': false
    },
    name: { type: :string, example: 'Pro', 'x-nullable': false },
    permissions: {
      type: :array,
      items: { "$ref" => "#/definitions/permission_group_permission" }
    }
  },
  required: [
    :id,
    :name
  ]
}

PERMISSION_GROUP_RESOURCE_SCHEMA = {
  type: "object",
  properties: {
    permission_group: { "$ref" => "#/definitions/permission_group" }
  },
  required: [
    :permission_group
  ]
}

PERMISSION_GROUPS_COLLECTION_SCHEMA = {
  type: "object",
  properties: {
    permission_groups: {
      type: "array",
      items: { "$ref" => "#/definitions/permission_group" }
    }
  },
  required: [
    :permission_groups
  ]
}
