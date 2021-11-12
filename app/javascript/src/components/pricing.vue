<template>
  <div>
    <div class="relative flex items-center justify-between pr-10">
      <div>
        <div class="flex items-center">
          <span>
            {{ pricing.name }}
          </span>
          <PluttoCopyableDiv
            class="ml-2 text-xs text-gray-800"
            :value="pricing.id"
          />
          <span class="flex items-center text-gray-800">
            <span class="ml-6 mr-2 plutto-icon">group</span>
            <span>{{ pricing.subscribedCustomers }}</span>
          </span>
        </div>
        <div
          class="text-sm text-gray-600"
          v-for="priceLogic in pricing.priceLogics"
          :key="priceLogic.id"
        >
          <span>{{ $t(`message.priceLogics.types.${priceLogic.type}`) }}</span>
          <span v-if="!priceLogic.tiers"> | ${{ priceLogic.price }}</span>
          <template v-else>
            | <span
              v-for="tier in priceLogic.tiers"
              :key="tier.id"
            > ${{ tier.price }} \</span>
          </template>
          <span v-if="priceLogic.metered && meter"> @ {{ meter.name }}</span>
          <span v-if="priceLogic.metered && priceLogic.meterCountMethod"> | {{ priceLogic.meterCountMethod }}</span>
        </div>
      </div>
      <span
        class="absolute top-0 right-0 flex items-center h-full text-xl cursor-pointer plutto-icon"
        :class="{ 'transform rotate-180': expanded }"
        @click="expanded = !expanded"
      >
        expand_more
      </span>
    </div>
    <template v-if="expanded">
      <div class="w-full m-auto space-y-8 divide-y divide-gray-700 md:max-w-xl">
        <div class="mt-8 mb-4 text-lg">
          Price Logics
        </div>
        <PriceLogics
          :model-value="pricing.priceLogics"
          :edit="false"
        />
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PriceLogics from '@/components/price-logics';
import PluttoCopyableDiv from '@/components/plutto-copyable-div';

export default {
  components: { PriceLogics, PluttoCopyableDiv },
  props: {
    pricing: {
      type: Object,
      required: true,
    },
    meter: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      expanded: false,
    };
  },
  computed: {
    ...mapState({
      loading: state => state.meters.loading,
    }),
  },
};
</script>
