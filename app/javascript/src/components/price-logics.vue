<template>
  <div>
    <button
      class="btn"
      @click.prevent="addPriceLogic"
    >
      Add Price Logic
    </button>
    <div class="my-8">
      <PriceLogic
        v-for="index in priceLogics.length"
        :key="index"
        v-model="priceLogics[index - 1]"
      />
    </div>
  </div>
</template>

<script>
import PriceLogic from '@/components/price-logic';

export default {
  components: { PriceLogic },
  props: {
    modelValue: {
      type: Array,
      default: () => [],
    },
  },
  beforeMount() {
    if (this.modelValue) this.priceLogics = this.modelValue;
    else this.priceLogics = [{ type: 'PriceLogic::Volume', price: 0, tiers: null }];
  },
  methods: {
    addPriceLogic() {
      this.priceLogics.push({ type: 'PriceLogic::FlatFee', price: 0, tiers: null });
    },
  },
  computed: {
    priceLogics: {
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
