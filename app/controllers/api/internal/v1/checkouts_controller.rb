class Api::Internal::V1::CheckoutsController < Api::Internal::V1::BaseController
  def show
    records = decode_records
    respond_with(records[params[:type]], show: true)
  end

  def update
    records = decode_records
    record = records[params[:type]]
    record&.update!(params[:record].permit!)
    respond_with(record)
  end

  private

  def decode_records
    # key should be like:
    # "invoice|invoice_3052749d8c4a54ae2f772884||customer|customer_b3f623b6ddbb5f38fde7442a"
    key = EncryptionService.decrypt(params[:token])
    items = key.split('||')
    items.reverse.reduce({}) do |acc, item|
      model, id = item.split('|')
      acc[model] = model.camelize.constantize.find(id)
      acc
    end
  rescue => e # rubocop:disable Style/RescueStandardError
    logger.error e.message
    logger.error e.backtrace.join('\n')
    Raven.capture_exception(e)
    raise ApiException::Errors::Unauthorized.new(detail: "Invalid token")
  end
end
