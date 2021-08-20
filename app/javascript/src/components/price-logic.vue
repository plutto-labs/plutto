<template>
  <div>
    <div class="relative flex items-center py-8 border border-gray-700">
      <div class="flex-1">
        <div class="sm:col-span-3 md:ml-8">
          <label
            for="meter-type"
            class="block text-sm font-medium text-gray-100"
          >
            Type
          </label>
          <PluttoDropdown
            class="mt-2"
            :selected="$t(`message.priceLogics.types.${priceLogic.type}`)"
            :options="dropdownOptions"
            @selected="(priceLogicType) => updatePriceLogic('type', priceLogicType)"
          />
          <div class="mt-2 text-sm text-gray-200">
            {{ $t(`message.priceLogics.descriptions.${priceLogic.type}`) }}
          </div>
        </div>
        <div class="mt-4 md:mx-8">
          <template v-if="priceLogic.tiered">
            <PriceLogicTiers
              :first-row-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the first'"
              :other-rows-text="priceLogic.type === 'PriceLogic::Volume' ? 'Total of units' : 'For the next'"
              :measurement-text="priceLogic.type === 'PriceLogic::StairStep' ? 'Tier fee' : 'Per unit' "
              v-model="priceLogic.tiers"
            />
          </template>
          <template v-else>
            <div class="flex">
              <div class="flex items-end justify-center plutto-input">
                <span class="plutto-input__icon">
                  attach_money
                </span>
                <input
                  type="number"
                  class="plutto-input__input"
                  v-model.number="priceLogic.price"
                  step="0.01"
                  min="0"
                >
              </div>
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
import PriceLogicTiers from '@/components/price-logic-tiers';
import PluttoDropdown from '@/components/plutto-dropdown';

export default {
  components: { PriceLogicTiers, PluttoDropdown },
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
    dropdownOptions() {
      return Object.keys(this.tierOptions).map((key) => (
        { value: key, label: this.$t(`message.priceLogics.types.${key}`) }
      ));
    },
  },
};
</script>
