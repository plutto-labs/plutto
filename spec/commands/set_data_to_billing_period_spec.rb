require 'rails_helper'

describe SetDataToBillingPeriod do
  let(:count_type) { 'initial_count' }
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:subscription) { create(:subscription, customer: customer) }
  let!(:billing_period) { create(:billing_period, subscription: subscription) }

  def perform
    described_class.for(billing_period: billing_period, count_type: count_type)
  end

  describe '#perform' do
    context 'when organization have meters' do
      before do
        create_list(:meter, 3, organization: organization)
      end

      it 'creates a billing period meter data for each meter' do
        expect { perform }.to change { BillingPeriodMeterData.count }.by(3)
      end
    end

    context 'when organization dont have meters' do
      it 'creates a billing period meter data for each meter' do
        expect { perform }.to change { BillingPeriodMeterData.count }.by(0)
      end
    end

    context 'when count type is initial_count' do
      before do
        meter = create(:meter, organization: organization)
        create(:meter_count, meter: meter, customer: customer, count: 10)
      end

      it 'calls update with correct params' do
        perform
        expect(billing_period.billing_period_meter_datas.last.initial_count).to eq(10)
      end
    end

    context 'when count type is final_count' do
      let(:count_type) { 'final_count' }

      before do
        meter = create(:meter, organization: organization)
        create(:meter_count, meter: meter, customer: customer, count: 10)
      end

      it 'calls update with correct params' do
        perform
        expect(billing_period.billing_period_meter_datas.last.final_count).to eq(10)
      end
    end

    context 'when it has meter counts created' do
      before do
        create_list(:meter, 3, organization: organization)
        create(:meter_count, customer: customer, meter: Meter.first)
      end

      it 'only creates necessary meter counts' do
        expect { perform }.to change { MeterCount.count }.by(2)
      end
    end
  end
end
