<template>
  <div>
    <PriceLogic
      v-for="index in priceLogics.length"
      :key="index"
      :edit="edit"
      :allow-metered="allowMetered"
      :index="index - 1"
      v-model="priceLogics[index - 1]"
    >
      <template
        v-if="edit"
        #delete
      >
        <span
          class="absolute text-2xl text-gray-700 cursor-pointer top-2 right-2 plutto-icon"
          @click="deletePriceLogic(index)"
        >
          close
        </span>
      </template>
      <template
        #separator
        v-if="index < priceLogics.length"
      >
        <div class="flex justify-center w-full h-6 my-4 text-gray-800">
          <span class="material-icons">
            add
          </span>
        </div>
      </template>
    </PriceLogic>
    <div
      v-if="edit"
      class="flex justify-center w-full mt-8"
    >
      <button
        class="relative flex items-center justify-center w-full py-8 text-gray-600 border border-gray-200 border-dashed"
        @click.prevent="addPriceLogic"
      >
        <span class="mr-2 plutto-icon">add</span>
        Add Price Logic
      </button>
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
    edit: {
      type: Boolean,
      default: true,
    },
    allowMetered: {
      type: Boolean,
      default: true,
    },
  },
  beforeMount() {
    if (this.modelValue && this.modelValue.length > 0) this.priceLogics = this.modelValue;
    else this.priceLogics = [{ type: 'PriceLogic::FlatFee', price: 0, tiers: null, meterId: null }];
  },
  methods: {
    addPriceLogic() {
      this.priceLogics.push({ type: 'PriceLogic::FlatFee', price: 0, tiers: null, meterId: null });
    },
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
