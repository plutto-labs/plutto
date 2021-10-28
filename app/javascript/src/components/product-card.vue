<template>
  <div class="relative flex flex-col border border-gray-300 rounded">
    <div class="flex-1 px-4 pt-6">
      <div class="flex items-center justify-between">
        <div class="text-xl">
          {{ product.name }}
        </div>
        <span
          v-if="product.meter"
          class="text-sm"
        >
          Meter: {{ product.meter.name }}
        </span>
      </div>
      <PluttoCopyableDiv
        class="text-gray-100 text-2xs"
        :value="product.id"
      />
      <div class="flex flex-col gap-4 p-4 my-4 overflow-y-auto bg-gray-800 border border-gray-400 rounded max-h-64">
        <div
          class="relative flex flex-col p-4 bg-gray-900 border border-gray-400 rounded text-2xs"
          v-for="pricing in product.pricings"
          :key="pricing.id"
        >
          <span
            class="absolute top-0 right-0 px-4 ml-4 border-b border-l border-gray-300 rounded-bl text-primary text-2xs"
          > {{ pricing.currency }} </span>
          <span class="text-sm"> {{ pricing.name }} </span>
          <PluttoCopyableDiv
            :value="pricing.id"
          />
          <span>{{ priceLogicSummary(pricing.priceLogics) }}</span>
        </div>
      </div>
    </div>
    <div
      @click="$router.push({ name: 'product', params: { id: product.id } })"
      class="px-4 py-2 text-xs text-right text-gray-200 cursor-pointer"
    >
      Details
    </div>
  </div>
</template>

<script>
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: { PluttoCopyableDiv },
  props: {
    product: {
      type: Object,
      required: true,
    },
  },
  methods: {
    priceLogicSummary(priceLogics) {
      return priceLogics.map((pl) => this.$t(`message.priceLogics.types.${pl.type}`)).join(' + ');
    },
  },
};
</script>

<style lang="scss" scoped>
.plutto-icon {
  font-family: 'Material Icons';
}
</style>
