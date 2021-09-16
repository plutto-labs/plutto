class Api::V1::MeterEventsController < Api::V1::BaseController
  PARAMS = MeterEvent.attribute_names + ['customer_id']
  wrap_parameters include: PARAMS

  def create
    authorize(MeterEvent)

    meter_event = CreateNewMeterEvent.for(
      timestamp: create_params['timestamp'],
      amount: create_params['amount'],
      action: create_params['action'],
      meter_id: create_params['meter_id'],
      customer_id: create_params['customer_id'],
      idempotency_key: create_params['idempotency_key'],
      organization: current_bearer
    )
    respond_with meter_event
  end

  private

  def create_params
    params.require(:meter_event).permit(PARAMS)
  end
end
