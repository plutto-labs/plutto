<template>
  <div>
    <div class="mb-8">
      <PriceLogic
        v-for="index in priceLogics.length"
        :key="index"
        v-model="priceLogics[index - 1]"
      >
        <template
          #delete
        >
          <span
            class="absolute text-2xl text-gray-200 cursor-pointer top-2 right-2 plutto-icon"
            @click="deletePriceLogic(index)"
          >
            close
          </span>
        </template>
        <template
          #separator
          v-if="index < priceLogics.length"
        >
          <div class="flex justify-center w-full h-4 my-4">
            <span class="material-icons">
              add
            </span>
          </div>
        </template>
      </PriceLogic>
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
    if (this.modelValue && this.modelValue.length > 0) this.priceLogics = this.modelValue;
    else this.priceLogics = [{ type: 'PriceLogic::FlatFee', price: 0, tiers: null }];
  },
  methods: {
    deletePriceLogic(index) {
      this.priceLogics.splice(index - 1, 1);
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
