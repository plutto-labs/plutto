class Api::Internal::V1::BaseController < Api::BaseController
  before_action do
    self.namespace_for_serializer = ::Api::Internal::V1
  end
end
