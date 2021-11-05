class FilterCustomers < PowerTypes::Command.new(:customers, :options)
  def perform
    filter(:search) do |customers|
      customers.search_like("lower(customers.name)", @options[:search].downcase).or(
        customers.search_like("lower(customers.email)", @options[:search].downcase)
      )
    end
    @customers
  end

  private

  def filter(_option)
    @customers = yield @customers if @options.key? _option
  end
end
