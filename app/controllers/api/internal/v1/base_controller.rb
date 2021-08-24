class Api::Internal::V1::BaseController < Api::BaseController
  before_action do
    self.namespace_for_serializer = ::Api::Internal::V1
  end

  after_action do
    if current_user
      Analytics.track(
        user_id: current_user.id,
        event: "internal #{action_name} #{controller_name}"
      )
    end
  end
end
