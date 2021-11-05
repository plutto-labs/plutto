<template>
  <div class="relative flex flex-col border border-gray-300 rounded">
    <div class="flex-1 px-4 pt-6">
      <div class="items-center justify-between md:flex">
        <div class="md:text-lg">
          {{ product.name }}
        </div>
        <span
          v-if="product.meter"
          class="text-sm text-green-300"
        >
          Meter: {{ product.meter.name }}
        </span>
      </div>
      <PluttoCopyableDiv
        class="mb-4 text-gray-100 text-2xs"
        :value="product.id"
      />
      <div class="overflow-y-scroll max-h-40">
        <div
          class="relative justify-between p-2 border-t border-gray-300 md:flex text-2xs"
          v-for="pricing in product.pricings"
          :key="pricing.id"
        >
          <div class="items-center md:flex">
            <div class="mr-4 text-xs md:text-sm">
              {{ pricing.name }} [{{ pricing.currency }}]
            </div>
            <div class="text-gray-300 md:text-sm text-2xs">
              {{ pricingSummary(pricing) }}
            </div>
          </div>
          <PluttoCopyableDiv
            class="text-2xs"
            :value="pricing.id"
          />
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
    pricingSummary(pricing) {
      const summary = [];
      pricing.priceLogics.forEach((priceLogic) => {
        let priceLogicText = this.$t(`message.priceLogics.types.${priceLogic.type}`);
        if (priceLogic.tiers) {
          const tiers = priceLogic.tiers.map((tier) => this.formatCurrency(tier.price, pricing.currency));
          priceLogicText += ` | ${tiers.join(' → ')}`;
        } else priceLogicText += ` | ${this.formatCurrency(priceLogic.price, pricing.currency)}`;
        if (priceLogic.metered && priceLogic.meterCountMethod) priceLogicText += ` | ${priceLogic.meterCountMethod}`;

        summary.push(priceLogicText);
      });

      return summary.join(' + ');
    },
  },
};
</script>

<style lang="scss" scoped>
.plutto-icon {
  font-family: 'Material Icons';
}
</style>
