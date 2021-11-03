<template>
  <div>
    <div class="relative flex items-center py-8 border border-gray-700">
      <div class="flex-1">
        <div class="block md:mx-8">
          <div class="inline-block sm:col-span-3">
            <label
              for="meter-type"
              class="text-sm font-medium text-gray-100"
            >
              Charge
            </label>
            <PluttoDropdown
              class="mx-2 mt-2"
              v-if="edit"
              :selected="priceLogic.type"
              :options="dropdownOptions"
              label-key="label"
              value-key="value"
              @selected="(priceLogicType) => updatePriceLogic('type', priceLogicType)"
            />
            <div
              class="inline-block w-auto px-4 py-2 mx-2 mt-2 text-sm font-medium bg-gray-700 border-gray-500 rounded-md"
              v-else
            >
              {{ $t(`message.priceLogics.types.${priceLogic.type}`) }}
            </div>
          </div>
          <template v-if="priceLogic.metered">
            <div class="inline-block sm:col-span-3">
              <label
                for="meter-type"
                class="text-sm font-medium text-gray-100"
              >
                using
              </label>
              <PluttoDropdown
                class="mx-2 mt-2"
                v-if="edit"
                :selected="priceLogic.meterCountMethod"
                :options="meterCountMethods"
                label-key="label"
                value-key="value"
                @selected="(method) => priceLogic.meterCountMethod = method"
              />
              <div
                class="inline-block px-4 py-2 mx-2 mt-2 text-sm bg-gray-700 border-gray-500 rounded-md shadow-sm text-gray-50"
                v-else
              >
                {{ meterCountMethods.find(method => method.value == priceLogic.meterCountMethod).label }}
              </div>
            </div>
          </template>
        </div>
        <div class="mt-2 text-sm text-gray-200 sm:col-span-3 md:ml-8">
          {{ $t(`message.priceLogics.descriptions.${priceLogic.type}`) }}
        </div>
        <div class="mt-4 md:mx-8">
          <template v-if="priceLogic.tierable">
            <PriceLogicTiers
              :first-row-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the first'"
              :other-rows-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the next'"
              :measurement-text="priceLogic.type === 'PriceLogic::StairStep' ? 'Tier fee' : 'Per unit' "
              v-model="priceLogic.tiers"
              :edit="edit"
              :price-logic-index="index"
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
    allowMetered: {
      type: Boolean,
      default: true,
    },
    index: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      priceLogicOptions: {
        'PriceLogic::FlatFee': { tierable: false, metered: false },
        'PriceLogic::PerUnit': { tierable: false, metered: true },
        'PriceLogic::StairStep': { tierable: true, metered: true },
        'PriceLogic::Tiered': { tierable: true, metered: true },
        'PriceLogic::Volume': { tierable: true, metered: true },
      },
      meterCountMethods: [
        { value: 'period_sum', label: 'the current period usage' },
        { value: 'history_sum', label: 'the historic usage' },
      ],
      selectedMeterCountMethod: null,
    };
  },
  async mounted() {
    await this.$store.dispatch('GET_METERS');
    if (this.modelValue) this.updatePriceLogic('type', this.modelValue.type);
  },
  methods: {
    updatePriceLogic(key, val) {
      if (key === 'type') this.priceLogic = Object.assign(this.priceLogic, this.allowedPriceLogicOptions[val]);
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
      return Object.keys(this.allowedPriceLogicOptions).map((key) => (
        { value: key, label: this.$t(`message.priceLogics.types.${key}`) }
      ));
    },
    allowedPriceLogicOptions() {
      if (this.allowMetered) return this.priceLogicOptions;

      const allowed = {};
      Object.keys(this.priceLogicOptions).forEach((key) => {
        if (!this.priceLogicOptions[key].metered) allowed[key] = this.priceLogicOptions[key];
      });

      return allowed;
    },
  },
};
</script>
