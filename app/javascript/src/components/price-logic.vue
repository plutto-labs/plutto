<template>
  <div>
    <label
      for="meter-type"
      class="block text-sm font-medium text-gray-50 sm:mt-px sm:pt-2 sm:ml-4"
    >
      Type
    </label>
    <div>
      <select
        class="block w-full max-w-lg bg-gray-700 border-gray-500 rounded-md text-gray-50 focus:ring-0 focus:border-primary sm:max-w-xs sm:text-sm"
        @change="updatePriceLogic('type', $event.target.value)"
      >
        <option
          v-for="(_, key) in tierOptions"
          :key="key"
          :value="key"
          :selected="key === priceLogic.type"
        >
          {{ $t(`message.priceLogics.types.${key}`) }}
        </option>
      </select>
    </div>
    <div>
      <template v-if="priceLogic.tiered">
        <PriceLogicTiers
          :first-row-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the first'"
          :other-rows-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the next'"
          v-model="priceLogic.tiers"
        />
      </template>
      <template v-else>
        <div class="flex">
          <p class="pl-6 my-auto text-sm font-medium">
            {{ currency }}
          </p>
          <div class="flex items-end justify-center">
            <input
              type="number"
              class="pl-2 pr-6 bg-gray-800 border border-gray-800 rounded-lg focus:outline-none focus:ring-gray-800 focus:border-gray-800 plutto-input"
              v-model.number="priceLogic.price"
            >
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import PriceLogicTiers from '@/components/price-logic-tiers';

export default {
  components: { PriceLogicTiers },
  props: {
    currency: {
      type: String,
      default: '$',
    },
    modelValue: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      tierOptions: {
        'PriceLogic::FlatFee': { tiered: false },
        'PriceLogic::PerUnit': { tiered: false },
        'PriceLogic::StairStep': { tiered: true },
        'PriceLogic::Tiered': { tiered: true },
        'PriceLogic::Volume': { tiered: true },
      },
    };
  },
  mounted() {
    if (this.modelValue) this.updatePriceLogic('type', this.modelValue.type);
  },
  methods: {
    updatePriceLogic(key, val) {
      if (key === 'type') this.priceLogic = Object.assign(this.priceLogic, this.tierOptions[val]);
      this.priceLogic = { ...this.priceLogic, ...{ [key]: val } };
    },
  },
  computed: {
    priceLogic: {
      get() {
        return this.modelValue;
      },
      set(val) {
        if (val) this.$emit('update:modelValue', val);
      },
    },
  },
};
</script>
