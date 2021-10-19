describe CustomerAnalyticsService do
  def build(*_args)
    described_class.new(*_args)
  end

  def formatted_date(minus_n_days)
    (Date.current - minus_n_days.days).strftime('%d-%b')
  end

  let(:customer) { create(:customer) }
  let(:service) { build(customer: customer) }

  before do
    Timecop.freeze(Time.zone.local(2021, 12, 1))
  end

  describe '#meter_events_data' do
    it 'returns an object with each meter' do
      meter = create(:meter, name: 'api calls')
      meter2 = create(:meter)
      create(:meter_count, customer: customer, meter: meter)
      create(:meter_count, customer: customer, meter: meter2)

      expect(service.meter_events_data).to be_a(Hash)
      expect(service.meter_events_data.keys.count).to eq(2)
    end

    context 'when there are no meter events' do
      it 'returns an empty hash' do
        expect(service.meter_events_data).to be_a(Hash)
        expect(service.meter_events_data.keys.count).to eq(0)
      end
    end

    context 'when there are meter events' do
      let(:meter) { create(:meter, name: 'api calls') }
      let(:meter_count) { create(:meter_count, customer: customer, meter: meter) }

      before do
        create(:meter_count, customer: customer)

        create(:meter_event, meter: meter_count.meter, meter_count: meter_count,
                             action: 'increment', timestamp: Time.current - 1.day, amount: 10,
                             current_meter_count: 60)
        create(:meter_event, meter: meter_count.meter, meter_count: meter_count,
                             action: 'increment', timestamp: Time.current - 2.days, amount: 20,
                             current_meter_count: 50)
        create(:meter_event, meter: meter_count.meter, meter_count: meter_count,
                             action: 'increment', timestamp: Time.current - 3.days, amount: 30,
                             current_meter_count: 30)
      end

      it 'returns the correct information por each meter' do
        meter_data = service.meter_events_data[meter.name].to_a
        expect(meter_data[-2]).to eq([formatted_date(1), 60.0])
        expect(meter_data[-3]).to eq([formatted_date(2), 50.0])
        expect(meter_data[-4]).to eq([formatted_date(3), 30.0])
      end
    end
  end
end
