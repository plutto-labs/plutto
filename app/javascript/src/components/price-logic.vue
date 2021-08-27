<template>
  <div>
    <div class="relative flex items-center py-8 border border-gray-700">
      <div class="flex-1">
        <div class="flex">
          <div class="sm:col-span-3 md:ml-8">
            <label
              for="meter-type"
              class="block text-sm font-medium text-gray-100"
            >
              Type
            </label>
            <PluttoDropdown
              class="mt-2"
              v-if="edit"
              :selected="priceLogic.type"
              :options="dropdownOptions"
              label-key="label"
              value-key="value"
              @selected="(priceLogicType) => updatePriceLogic('type', priceLogicType)"
            />
            <div
              class="inline-block w-auto px-4 py-2 mt-2 text-sm font-medium bg-gray-700 border-gray-500 rounded-md"
              v-else
            >
              {{ $t(`message.priceLogics.types.${priceLogic.type}`) }}
            </div>
          </div>
          <template v-if="priceLogic.metered">
            <div class="sm:col-span-3 md:ml-8">
              <label
                for="meter-type"
                class="block text-sm font-medium text-gray-100"
              >
                Meter
              </label>
              <PluttoDropdown
                class="mt-2"
                v-if="edit"
                :selected="priceLogic.meterId"
                :options="meters"
                label-key="name"
                value-key="id"
                @selected="(meterId) => updatePriceLogic('meterId', meterId)"
              />
              <div
                class="flex items-center px-4 py-2 mt-2 text-sm bg-gray-700 border-gray-500 rounded-md shadow-sm text-gray-50"
                v-else
              >
                {{ meters && meters.find(meter => meter.id == priceLogic.meterId).name }}
              </div>
            </div>
          </template>
        </div>
        <div class="mt-2 text-sm text-gray-200 sm:col-span-3 md:ml-8">
          {{ $t(`message.priceLogics.descriptions.${priceLogic.type}`) }}
        </div>
        <div class="mt-4 md:mx-8">
          <template v-if="priceLogic.tiered">
            <PriceLogicTiers
              :first-row-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the first'"
              :other-rows-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the next'"
              :measurement-text="priceLogic.type === 'PriceLogic::StairStep' ? 'Tier fee' : 'Per unit' "
              v-model="priceLogic.tiers"
              :edit="edit"
            />
          </template>
          <template v-else>
            <label
              for="amount"
              class="block mt-2 text-sm font-medium text-gray-100"
            >
              Amount
            </label>
            <div class="flex items-end justify-center mt-2 plutto-input">
              <span class="w-6 plutto-input__icon">payments</span>
              <component
                :is="edit ? 'input' : 'div'"
                type="number"
                class="flex items-center plutto-input__input"
                :value="priceLogic.price"
                @input="e => priceLogic.price = e.target.value"
                step="0.01"
                min="0"
              >
                {{ formatCurrency(priceLogic.price, priceLogic.priceCurrency) }}
              </component>
            </div>
          </template>
        </div>
      </div>
      <slot name="delete" />
    </div>
    <slot name="separator" />
  </div>
</template>

<script>
import { mapState } from 'vuex';

import PriceLogicTiers from '@/components/price-logic-tiers';
import PluttoDropdown from '@/components/plutto-dropdown';

export default {
  components: { PriceLogicTiers, PluttoDropdown },
  props: {
    modelValue: {
      type: Object,
      default: null,
    },
    edit: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {
      priceLogicOptions: {
        'PriceLogic::FlatFee': { tiered: false, metered: false },
        'PriceLogic::PerUnit': { tiered: false, metered: true },
        'PriceLogic::StairStep': { tiered: true, metered: true },
        'PriceLogic::Tiered': { tiered: true, metered: true },
        'PriceLogic::Volume': { tiered: true, metered: true },
      },
    };
  },
  async mounted() {
    await this.$store.dispatch('GET_METERS');
    if (this.modelValue) this.updatePriceLogic('type', this.modelValue.type);
  },
  methods: {
    updatePriceLogic(key, val) {
      if (key === 'type') this.priceLogic = Object.assign(this.priceLogic, this.priceLogicOptions[val]);
      this.priceLogic = { ...this.priceLogic, ...{ [key]: val } };
    },
  },
  computed: {
    ...mapState({
      meters: state => state.meters.meters,
    }),
    priceLogic: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
    dropdownOptions() {
      return Object.keys(this.priceLogicOptions).map((key) => (
        { value: key, label: this.$t(`message.priceLogics.types.${key}`) }
      ));
    },
  },
};
</script>
