require 'rails_helper'

describe MeterEventObserver do
  let(:meter) { build(:meter) }
  let(:meter_count) { build(:meter_count, meter: meter) }
  let(:meter_event) { build(:meter_event, meter: meter, meter_count: meter_count) }

  def trigger(type, event)
    described_class.trigger(type, event, meter_event)
  end

  describe 'MeterEventObserver behaviour' do
    before do
      allow(meter_count).to receive(:update_count).with(meter_event)
    end

    it 'updates and save meter_count' do
      trigger :before, :save
      expect(meter_count).to have_received(:update_count).with(meter_event)
      expect(meter_event.current_meter_count).to eq(meter_count.count)
    end
  end
end
